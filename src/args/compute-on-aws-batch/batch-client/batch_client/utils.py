from __future__ import (
    annotations,
)

from collections.abc import (
    Callable,
)
from dataclasses import (
    dataclass,
    field,
)
from fa_purity import (
    FrozenList,
    Maybe,
    PureIter,
    Result,
    result,
    ResultE,
)
from fa_purity.pure_iter import (
    PureIterTransform,
)
from fa_purity.union import (
    Coproduct,
    CoproductFactory,
)
from fa_purity.utils import (
    raise_exception,
)
from typing import (
    Generic,
    NoReturn,
    TypeVar,
)

_T = TypeVar("_T")
_S = TypeVar("_S")
_F = TypeVar("_F")


@dataclass(frozen=True)
class _Private:
    pass


@dataclass(frozen=True)
class LibraryBug(Exception):
    traceback: Exception

    def __str__(self) -> str:
        return f"If raised then there is a bug in the `batch_client` library"


def str_to_int(raw: str) -> ResultE[int]:
    try:
        return Result.success(int(raw))
    except ValueError as err:
        return Result.failure(Exception(err))


def int_to_str(item: int) -> str:
    return str(item)


def handle_value_error(transform: Callable[[], _T | NoReturn]) -> ResultE[_T]:
    try:
        return Result.success(transform())
    except ValueError as err:
        return Result.failure(Exception(err))


def handle_key_error(transform: Callable[[], _T | NoReturn]) -> ResultE[_T]:
    try:
        return Result.success(transform())
    except KeyError as err:
        return Result.failure(Exception(err))


def handle_index_error(transform: Callable[[], _T | NoReturn]) -> ResultE[_T]:
    try:
        return Result.success(transform())
    except IndexError as err:
        return Result.failure(Exception(err))


def get_index(items: FrozenList[_T], index: int) -> Maybe[_T]:
    return Maybe.from_result(
        handle_index_error(lambda: items[index]).alt(lambda _: None)
    )


@dataclass(frozen=True)
class Natural:
    _private: _Private = field(repr=False, hash=False, compare=False)
    to_int: int

    @staticmethod
    def assert_natural(raw: int) -> ResultE[Natural]:
        if raw >= 0:
            return Result.success(Natural(_Private(), raw))
        err = ValueError("The supplied integer is not a natural number")
        return Result.failure(Exception(err))

    @classmethod
    def abs(cls, raw: int) -> Natural:
        return (
            cls.assert_natural(abs(raw))
            .alt(LibraryBug)
            .alt(raise_exception)
            .unwrap()
        )


def extract_single(items: PureIter[_T]) -> Coproduct[_T, PureIter[_T]]:
    _factory: CoproductFactory[_T, PureIter[_T]] = CoproductFactory()
    single_element = (
        items.enumerate(1)
        .find_first(lambda t: t[0] >= 2)
        .map(lambda _: False)
        .value_or(True)
    )
    if single_element:
        return _factory.inl(
            items.enumerate(1)
            .find_first(lambda t: t[0] == 1)
            .to_result()
            .alt(lambda _: LibraryBug(Exception("no first element")))
            .unwrap()[1]
        )
    return _factory.inr(items)


class HandledException(Exception):
    pass


@dataclass(frozen=True)
class ResultUnwrapper:
    _inner: _Private = field(repr=False, hash=False, compare=False)

    def unwrap(self, item: Result[_S, _F]) -> _S:
        return item.alt(HandledException).alt(raise_exception).unwrap()


def unwrap_context(
    unwrap_block: Callable[[ResultUnwrapper], _T]
) -> ResultE[_T]:
    try:
        return Result.success(unwrap_block(ResultUnwrapper(_Private())))
    except HandledException as err:
        return Result.failure(Exception(err))
