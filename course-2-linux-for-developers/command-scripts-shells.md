# Visual diagram to show how **commands, scripts, and shells interact**:

```
        +------------------+
        |   User/Terminal  |
        +------------------+
                  |
                  v
        +------------------+
        |      Shell       |   <-- Command-line interpreter
        |  (bash, zsh,    |
        |   sh, csh, etc) |
        +------------------+
          |          |
   Interactive    Script file
   commands          |
   (typed)           v
                 +------------------+
                 |   Script file    |
                 | #!/bin/bash      |
                 | find . -name ... |
                 +------------------+
                          |
                          v
                +------------------+
                |  Operating System |
                | Executes commands |
                +------------------+
                          |
                          v
                 +------------------+
                 |     Output       |
                 | Files, Text, etc |
                 +------------------+
```

**Explanation of flow:**

1. **Interactive commands**: You type commands directly in the terminal → the shell interprets them → OS executes → you see output.
2. **Script execution**: You write commands in a script file → the shell specified in `#!` interprets them → OS executes → output appears.

---

## Key shells:

sh → Original, simple, standard for scripts.

csh / tcsh → C-style syntax, better for interactive use.

ksh → Combines sh scripting with interactive features from csh.

bash → Most common today, highly compatible, good for scripts and interactive use.

zsh → Modern, feature-rich, often used with frameworks like Oh My Zsh for productivity.
