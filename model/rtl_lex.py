"""Shared lexical views for framed RTL and Agent prechecks, not an HDL parser."""
from __future__ import annotations
import re

ID = r"[A-Za-z_][A-Za-z0-9_$]*"
_MODULE = re.compile(r"\bmodule\s+(?:(?:automatic|static)\s+)?(?P<escaped>\\)?(?P<name>"+ID+r")(?(escaped)\s+|\s*)(?=[(#;])")
_NONCODE = re.compile(r'(?P<escaped>\\[^\s]+)|"(?:\\.|[^"\\])*"|/\*.*?\*/|//[^\n]*', re.S)


def mask_noncode(source: str, *, escaped_identifiers: bool = True) -> str:
    """Preserve offsets, newlines and separators; never concatenate tokens."""
    return _NONCODE.sub(lambda m: m.group() if m.lastgroup == "escaped" and not escaped_identifiers else re.sub(r"[^\r\n]", " ", m.group()), source)


def preprocessing_sensitive(source: str) -> bool:
    """Unexpanded directives/macros invalidate raw-text structural proofs."""
    return '`' in mask_noncode(source)


def constant_integer(expression: str) -> int | None:
    """Bounded decimal integer subset; unknown SV sizing/parameter syntax stays unknown."""
    import ast
    if len(expression) > 160: return None
    try:
        node=ast.parse(expression.strip(),mode='eval')
        if sum(1 for _ in ast.walk(node)) > 48: return None
        def value(n):
            if isinstance(n,ast.Constant) and type(n.value) is int: result=n.value
            elif isinstance(n,ast.UnaryOp) and isinstance(n.op,(ast.UAdd,ast.USub)):
                operand=value(n.operand);result=operand if isinstance(n.op,ast.UAdd) else -operand
            elif isinstance(n,ast.BinOp) and isinstance(n.op,(ast.Add,ast.Sub,ast.Mult)):
                a,b=value(n.left),value(n.right)
                result=a+b if isinstance(n.op,ast.Add) else a-b if isinstance(n.op,ast.Sub) else a*b
            else: raise ValueError('outside supported constant subset')
            if abs(result)>2**31-1: raise ValueError('constant limit')
            return result
        return value(node.body)
    except (SyntaxError,ValueError,TypeError,RecursionError): return None


def module_declarations(source: str):
    # Locate real keyword tokens in the structural view, then read declaration names
    # in the identifier-preserving view. Escaped \top is the same name as top.
    headers = mask_noncode(source, escaped_identifiers=False)
    return [match for keyword in re.finditer(r"\bmodule\b", mask_noncode(source))
            if (match := _MODULE.match(headers, keyword.start())) is not None]


def module_header(source: str, top_module: str) -> str | None:
    """Return a supported ANSI port body, including parameterized declarations."""
    clean = mask_noncode(source, escaped_identifiers=False)
    match = next((m for m in module_declarations(source) if m['name'] == top_module), None)
    if match is None:
        return None
    at = match.end()
    def skip_space(index):
        while index < len(clean) and clean[index].isspace(): index += 1
        return index
    def group(index):
        if index >= len(clean) or clean[index] != '(':
            return None
        depth = 0
        for end in range(index,len(clean)):
            if clean[end] == '(': depth += 1
            elif clean[end] == ')':
                depth -= 1
                if depth == 0: return clean[index+1:end], end+1
        return None
    at = skip_space(at)
    if at < len(clean) and clean[at] == '#':
        parameter = group(skip_space(at+1))
        if parameter is None: return None
        at = skip_space(parameter[1])
    ports = group(at)
    if ports is None or skip_space(ports[1]) >= len(clean) or clean[skip_space(ports[1])] != ';':
        return None
    return ports[0]


def lexical_fingerprint(source: str) -> tuple[str, str]:
    """Conservative token identity, never semantic equivalence or source identity."""
    import hashlib
    import json
    token = re.compile(r'(?P<space>\s+)|(?P<comment>/\*.*?\*/|//[^\n]*)|(?P<string>"(?:\\.|[^"\\])*")|(?P<number>(?:[0-9][0-9_]*\s*)?\'[sS]?[bBoOdDhH][0-9a-fA-F_xXzZ?]+|\'[01xXzZ]|[0-9][0-9_]*(?:\.[0-9_]+)?(?:[eE][+-]?[0-9_]+)?)|(?P<id>[A-Za-z_$][A-Za-z0-9_$]*)|(?P<op>\|->|\|=>|<->|&&&|#-#|#=#|:=|:/|\.\*|\(\*|\*\)|<<<|>>>|===|!==|==\?|!=\?|<<=|>>=|\*\*|&&|\|\||==|!=|<=|>=|<<|>>|\+\+|--|\+=|-=|\*=|/=|%=|&=|\|=|\^=|~&|~\||~\^|\^~|::|->|=>|\+:|-:|[(){}\[\];,:.#?@+*/%&|^~!=<>-])', re.S)
    tokens=[]; at=0
    while at < len(source):
        match=token.match(source,at)
        if not match:
            return 'raw', hashlib.sha256(source.encode()).hexdigest()
        if match.lastgroup not in {'space','comment'}:
            tokens.append((match.lastgroup,match.group()))
        at=match.end()
    return 'tokens', hashlib.sha256(json.dumps(tokens,separators=(',',':')).encode()).hexdigest()
