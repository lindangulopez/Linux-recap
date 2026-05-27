`folium` is correctly installed in the `coa` Conda environment.

# notebook kernel is using a different Python interpreter

Inside the notebook, run:

```python id="8py6qb"
import sys
print(sys.executable)
```

It should print:

```text
/home/linda/anaconda3/envs/coa/bin/python
```

If it prints something else (commonly `base` or `/usr/bin/python`), switch the notebook kernel.

To make sure `coa` appears as a selectable kernel, run in terminal:

```bash id="7t09lp"
conda install ipykernel
python -m ipykernel install --user --name coa --display-name "Python (coa)"
```

Then:

1. Restart Jupyter
2. Open notebook
3. Kernel → Change Kernel
4. Select **Python (coa)**

After that, `import folium` should work immediately.
