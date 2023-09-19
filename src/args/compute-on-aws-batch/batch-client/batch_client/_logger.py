from fa_purity import (
    Cmd,
)
import logging
import sys


def setup_logger(name: str) -> Cmd[None]:
    def _action() -> None:
        handler = logging.StreamHandler(sys.stderr)
        formatter = logging.Formatter("[%(levelname)s] %(message)s")
        handler.setFormatter(formatter)
        log = logging.getLogger(name)
        log.addHandler(handler)
        log.setLevel(logging.INFO)

    return Cmd.from_cmd(_action)
