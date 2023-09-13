from ._logger import (
    setup_logger,
)
from fa_purity.cmd import (
    unsafe_unwrap,
)

__version__ = "1.0.0"
unsafe_unwrap(setup_logger(__name__))
