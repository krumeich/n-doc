# n-doc Lua Code Refactoring Plan

This document outlines a structured refactoring plan to improve the quality of the Lua code in the n-doc project. The changes are organized into logical categories to ensure systematic improvement.

## 1. Code Duplication Removal

### 1.1 Remove Duplicate Functions
- **Issue**: `getSfr2Obj` function appears twice in cc_core.lua
- **Location**: Lines 224 and 228 in `/Users/krumeich/develop/n-doc/lua/cc_core.lua`
- **Action**: Remove the duplicate function definition
- **Status**: Completed - Duplicate function removed successfully

## 2. Function Naming Consistency

### 2.1 Standardize Function Names
- **Issue**: Inconsistent naming patterns across similar functions
- **Examples**: `getSfr2Sf` vs `getSfr2Subjobj`
- **Action**: Review and standardize all function naming conventions
- **Status**: Postponed - Changes would require extensive system-wide updates and risk breaking existing functionality

## 3. Code Documentation

### 3.1 Add Function Comments
- **Issue**: Missing inline documentation for most functions
- **Action**: Add explanatory comments for complex logic and function purposes
- **Status**: Completed - Added documentation to key functions

## 4. Code Structure Improvements

### 4.1 Function Organization
- **Issue**: Some complex functions could benefit from better organization
- **Action**: Refactor complex functions for better readability

## 5. Testing Verification

### 5.1 Verify Test Coverage After Changes
- **Issue**: Need to ensure all tests continue to pass after refactoring
- **Action**: Run full test suite after each category is completed

## Implementation Approach

1. **Phase 1**: Remove code duplication (1.1)
2. **Phase 2**: Address naming consistency (2.1) 
3. **Phase 3**: Add documentation (3.1)
4. **Phase 4**: Improve code structure (4.1)
5. **Phase 5**: Verify with tests (5.1)

Each phase should be completed systematically, with testing verification after each category.