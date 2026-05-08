# Update Folder & add files

```
data-management/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── conda.yml
│       └── slsa.yml
├── notebooks/
├── src/
└── ... (everything else)
```

The only thing to add to your notebooks is the small guard in notebook 04 (the Omniscape one) so the CI runner knows to skip Julia — it can't install Julia in ~5 minutes. Everything else should work without changes to your existing code.

Once you push, the **Actions** tab on GitHub becomes your dashboard — green ticks mean your code is healthy, red crosses tell you exactly which cell or function broke. Want me to walk through what to do if the first run fails?
