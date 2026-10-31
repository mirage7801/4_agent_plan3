# counter

Public specification: `task.txt` and `task.json`. Private evaluation material: `tb_counter.sv`, `constraints.xdc`, `reference.v`, and `faults/`. The reference is an 8-bit synchronous-reset, enable-gated modulo counter. The self-checking bench tests reset, count, hold/resume, in-flight reset, and FF-to-00 wrap. It prints `TEST_PASS` or a fatal diagnostic with cycle, inputs, expected, and actual values.
