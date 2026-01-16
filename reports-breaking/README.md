# Breaking Change Reports

This directory contains setup reports and action plans for breaking change migrations.

## File Naming Convention

### Setup Reports
`{package}-{version}-{date}-setup.md`

Examples:
- `ctbase-0.17.0-2026-01-16-setup.md`
- `ctmodels-0.7.0-2026-01-17-setup.md`

### Action Plans
`{package}-{version}-{date}-plan.md`

Examples:
- `ctbase-0.17.0-2026-01-16-plan.md`
- `ctmodels-0.7.0-2026-01-17-plan.md`

## Workflow

1. Run `/breaking-setup` to generate setup report
2. Run `/breaking-action-plan` with setup report to generate action plan
3. Follow action plan phases for migration
4. Keep reports for traceability

## Date Format

Use `YYYY-MM-DD` format for automatic sorting.

