"""Strict framed RTL extraction; real syntax checks belong to the compiler."""
from dataclasses import dataclass
import re
from .framing import ProtocolError, final_region
from .rtl_lex import mask_noncode, module_declarations, preprocessing_sensitive

class ExtractionError(ProtocolError):
    pass
class TopModuleMismatch(ExtractionError):
    pass
@dataclass(frozen=True)
class ExtractionResult:
    source: str
    source_kind: str
    selected_block_index: int | None
    discovered_modules: tuple[str,...]

def extract_rtl(response_text, top_module):
    try: source=final_region(response_text,"RTL_CODE")
    except ProtocolError as exc: raise ExtractionError(exc.code,str(exc)) from exc
    if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_$]*",top_module):
        raise ExtractionError("INVALID_TOP","invalid required top-module name")
    clean=mask_noncode(source)
    names=tuple(m["name"] for m in module_declarations(source))
    if preprocessing_sensitive(source):
        return ExtractionResult(source.rstrip()+"\n","tagged:RTL_CODE",None,names)
    if top_module not in names: raise TopModuleMismatch("TOP_MODULE_MISMATCH","required top-module declaration absent")
    if names!=(top_module,): raise ExtractionError("MODULE_COUNT","expected exactly one required module")
    if len(re.findall(r"\bmodule\b",clean))!=1 or len(re.findall(r"\bendmodule\b",clean))!=1:
        raise ExtractionError("INCOMPLETE_MODULE","expected one module/endmodule pair")
    return ExtractionResult(source.rstrip()+"\n","tagged:RTL_CODE",None,names)
