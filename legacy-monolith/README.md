# Legacy Monolith Example

This folder is not used by Docker Compose. It exists to show the "before" state.

A LAMP-style monolith usually combines:

- UI templates;
- backend logic;
- SQL queries;
- application configuration;
- one shared runtime and deployment unit.

In this lab, that monolith is split into:

- `frontend`: React/nginx;
- `backend`: Node.js API;
- `database`: PostgreSQL.

