# ADR-0001: Verified Stable Grids for Sudoku Classifier Testing

Status: accepted
Date: 2026-05-19

## Context
The Sudoku classifier relies on a cascading human-like logical solver engine to classify puzzle difficulties into Easy, Medium, Hard, and Expert.
Initially, the unit test suite attempted to mock clue layouts naively by filling cells with a single digit ('1'). This resulted in invalid, unsolvable boards which always fell through to the fallback 'expert' classification, causing test failures.
Additionally, the puzzle generator has a 1.2-second timeout. Performing random coordinate digging at runtime to dynamically generate exact difficulties is too slow and non-deterministic for fast unit tests.

## Decision
We executed a high-speed diagnostic script in `scratch_check.dart` using solved board shuffles and coordinate digging sequences to discover a 100% verified, mathematically solvable, and logically stable grid for all four difficulty levels. We replaced the naive mocked grid generation in `test/core/algorithms/sudoku_classifier_test.dart` with these pre-calculated deterministic grids.

## Alternatives Considered
1. **Dynamically generating grids during tests**: Rejected because the random digging algorithm is slow and may hit timeouts, which makes test execution slow and flaky.
2. **Naive mock clue-counts**: Rejected because the classifier requires valid boards to execute logical eliminations.

## Consequences
1. The test suite runs in milliseconds and is 100% deterministic.
2. The logic for scanning, pairs, intersection removal, naked pairs, hidden pairs, naked triples, X-Wing, and XY-Wing are validated on actual real-world solvable boards.

## Linked Plans
- [STAGE3_PLAN_ENGINE.md](file:///c:/Work/FlutterProjects/sudoku/.agent-plans/active/phase1_sudoku_mvp/STAGE3_PLAN_ENGINE.md)
