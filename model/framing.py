"""Final-area framing; never search prose for JSON or HDL."""
import re

class ProtocolError(ValueError):
    def __init__(self, code, message):
        self.code=code
        super().__init__(message)

RTL_TAG = "RTL_CODE"
ANSWER_TAG = "answer"


def output_contract(kind):
    if kind == "rtl":
        return ("OUTPUT CONTRACT (strict)\n"
                "- Start with <RTL_CODE> on its own line, then complete RTL, then </RTL_CODE> on its own line.\n"
                "- Alternatively, exactly one outer <answer> region may wrap that RTL_CODE region, all tags on separate lines.\n"
                "- Return exactly one complete required top-level module. No Markdown fences or surrounding prose. Complete RTL has absolute output priority.\n"
                "- Do not output reasoning, testbench, paths, run IDs or model metadata.\n")
    return "Return <answer> on its own line, exactly one JSON object, then </answer> on its own line. No Markdown or surrounding prose. "


def frame_final(body, kind):
    tag = RTL_TAG if kind == "rtl" else ANSWER_TAG
    return f"<{tag}>\n{body.strip()}\n</{tag}>"


def _accepted_body(value, tag):
    if tag == RTL_TAG and value.startswith("<answer>"):
        value = _final_body(value, ANSWER_TAG)
    body = _final_body(value, tag)
    # Reserved standalone wrappers inside the payload cannot form nested answers.
    if any(line.strip() in {"<answer>", "</answer>"} for line in body.splitlines()):
        raise ProtocolError("FINAL_BOUNDARY_ERROR", "nested answer regions are forbidden")
    return body


def final_region(text, tag):
    if not isinstance(text,str) or not text.strip():
        raise ProtocolError("EMPTY_RESPONSE","model response is empty")
    value=text.strip()
    if not value.startswith("<think>"):
        return _accepted_body(value, tag)
    # Think content is opaque, not nested XML. A quoted marker is ordinary
    # text unless its suffix is exactly the complete final response.
    matches=[]; errors=[]; found_close=False
    for marker in re.finditer(r"</think>", value[len("<think>"):]):
        found_close=True
        suffix=value[len("<think>")+marker.end():].strip()
        if not (suffix.startswith(f"<{tag}>") or tag == RTL_TAG and suffix.startswith("<answer>")):
            continue
        try:
            matches.append(_accepted_body(suffix, tag))
        except ProtocolError as exc:
            errors.append(exc)
    if len(matches)==1:
        return matches[0]
    if len(matches)>1:
        raise ProtocolError("AMBIGUOUS_THINK_BOUNDARY", "multiple thinking boundaries match a final region")
    if not found_close:
        raise ProtocolError("UNCLOSED_THINK", "thinking region has no closing marker")
    if errors:
        raise errors[0]
    raise ProtocolError("FINAL_BOUNDARY_ERROR", f"no thinking boundary is followed by a complete {tag} region")


def _final_body(value, tag):
    """Validate one exact final region; do not search its body for markers."""
    opening=f"<{tag}>"; closing=f"</{tag}>"
    # Reserved markers are line-delimited, including their end-of-input case.
    lines=value.splitlines()
    if sum(x.strip()==opening for x in lines)!=1 or sum(x.strip()==closing for x in lines)!=1:
        raise ProtocolError("FINAL_BOUNDARY_ERROR",f"expected exactly one complete {tag} region")
    if not lines or lines[0].strip()!=opening or lines[-1].strip()!=closing:
        raise ProtocolError("EXTRANEOUS_OUTPUT","final tags must be on separate lines with no surrounding prose")
    body="\n".join(lines[1:-1]).strip()
    if not body: raise ProtocolError("EMPTY_FINAL","final region is empty")
    if "```" in body: raise ProtocolError("NESTED_FENCE","Markdown fences are forbidden")
    return body
