from .arch import (
    forbidden_allowlist,
    project_dag,
)
from arch_lint.dag.check import (
    dag_map_completeness,
)
from arch_lint.forbidden import (
    check_forbidden,
)
from arch_lint.graph import (
    ImportGraph,
)
from arch_lint.private import (
    check_private,
)

root = "batch_client"


def test_dag_creation() -> None:
    project_dag()


def test_dag_completeness() -> None:
    graph = ImportGraph.build_graph(root, True)
    dag_map_completeness(project_dag(), graph, next(iter(graph.roots)))


def test_forbidden_creation() -> None:
    forbidden_allowlist()


def test_forbidden() -> None:
    graph = ImportGraph.build_graph(root, True)
    allowlist_map = forbidden_allowlist()
    check_forbidden(allowlist_map, graph)


def test_private() -> None:
    graph = ImportGraph.build_graph(root, False)
    check_private(graph, next(iter(graph.roots)))
