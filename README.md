# This is an example repo on how to package your code to production

## Quick start

```bash
pip install python-package-repo
```

```python
from test_packaging import ...
```

## Contributing

```bash
# clone the repo
git clone https://github.com/pnimeesha/python-package-prod.git

# install the dev dependencies
make install

# run the tests
make test
```



# 🐍 **Notes: Taking Python to Production – A Professional Onboarding Guide (Udemy)**

These notes summarize key learnings from the course, especially focused on production-ready Python packaging, pre-commit tools, automation, and CI/CD practices.

---

## 📌 **Pre-commit Framework**

### 🔧 What is it?

The **pre-commit framework** is a way to **automatically run checks and linters before committing code** to your Git repository. It helps maintain code quality and consistency across teams.

### 🔗 Resource:

[CI Approach 2 – The pre-commit framework](https://ericriddoch.notion.site/CI-Approach-2-The-pre-commit-framework-f3475c3543de437a9455139e57bc4be4)

### 🛠 How it Works:

* Configure hooks in `.pre-commit-config.yaml`
* Install it via `pre-commit install`
* Hooks like `black`, `isort`, `ruff`, etc., will auto-format/check your code before each commit

---

## 📦 **Section 11: Python Packaging**

---

### 🧠 Python Path Hacking

Used for quick experiments, not recommended in production code.

```python
from pathlib import Path
print(Path(__file__))          # Path to current file
print(Path(__file__).parent)   # Parent directory of current file

import sys
sys.path.insert(0, "<path-to-your-repo>")
```

**⚠️ Caution:** This is brittle and not maintainable—use `setuptools` or proper packaging techniques instead.

---

### 🧪 Creating Virtual Environment

```bash
python3 -m venv .venv
```

This creates an isolated Python environment to install dependencies without affecting global Python setup.

---

### 📁 `site-packages`

This is the directory inside your virtual environment (`.venv/lib/pythonX.Y/site-packages`) where Python packages get installed using `pip`.

---

### 📦 Using `setuptools` for Packaging

* `setuptools` simplifies packaging and distribution.
* Every venv includes `pip` and `setuptools`.

Steps:

1. Create `setup.py`:

```python
from setuptools import setup, find_packages

setup(
    name="your_package",
    version="0.0.1",
    packages=find_packages(),
    install_requires=["numpy"],
)
```

2. Build your package:

```bash
python setup.py sdist
```

3. Install the `.tar.gz` package locally:

```bash
pip install ./dist/your_package-0.0.1.tar.gz
```

4. Install in **editable** mode (great for development):

```bash
pip install --editable ./
```

---

### 📦 Source Distributions (sdist) – Pros and Cons

#### ✅ Advantages:

* Easy to generate and distribute

#### ❌ Disadvantages:

1. Assumes system dependencies (like `gcc`)
2. Slower, as it needs to compile on end-user machine
3. `setup.py` may contain arbitrary code – poses a **security risk**

---

## 🛞 Wheel Format

The `.whl` format (Python Wheel) is a **pre-built binary distribution**, making installations faster and safer.

```bash
pip install wheel
python setup.py bdist_wheel
```

Include in `setup.py`:

```python
setup_requires=["wheel"]
```

> Note: This installs `wheel` temporarily, so you can't import it in your code.

---

### 🧱 Modern Build System with `pyproject.toml`

Introduced by **PEP 518**, this replaces the need for `setup.py`.

```toml
[build-system]
requires = ["setuptools", "wheel"]
build-backend = "setuptools.build_meta"
```

Then build your project using:

```bash
pip install build
python -m build --sdist --wheel .
```

This creates both `.tar.gz` and `.whl` files.

---

### 🧹 Code Quality with Ruff

Run Ruff using configuration from `pyproject.toml`:

```bash
ruff check --config ./pyproject.toml your_package/
```

You can remove separate config files (`.flake8`, `.pylintrc`, etc.) and unify everything under `pyproject.toml`.

---

### 📁 Packaging Non-Python Files

#### Old Way – `MANIFEST.in` (still works):

```
recursive-include your_package/ *.json
```

#### New Way – via `pyproject.toml`:

```toml
[tool.setuptools.package-data]
your_package = ["**/*.json"]
```

If you're using **Hatchling** instead of Setuptools:

```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
```

Update the respective section accordingly.

---

### 📌 Saving and Viewing Dependencies

```bash
pip freeze > requirements.txt

# Visualizing dependency tree
pip install pipdeptree graphviz
pipdeptree -p your_package --graph-output png > dependency-graph.png
```

---

### 🎯 Optional Dependencies

In `pyproject.toml`:

```toml
[project.optional-dependencies]
dev = ["mypy", "ruff", "black"]
colors = ["rich"]
all = ["your_package[dev,colors]"]
```

Install all extras:

```bash
pip install '.[all]'
```

> In ZSH, quotes around the `.[all]` are required.

---

## 🚀 **Section 12: Continuous Delivery & Publishing to PyPI**

---

### 🧬 DevOps Context

* **Agile vs Waterfall:** Agile promotes iterative releases, making tools like PyPI/CD pipelines essential
* **PyPI vs TestPyPI:** TestPyPI is a sandboxed version of PyPI for testing uploads

---

### 🚀 Twine: Upload Tool

1. Generate API tokens:

   * [Test PyPI](https://test.pypi.org/)
   * [Production PyPI](https://pypi.org/)

2. Activate venv and build package:

```bash
python -m build --sdist --wheel .
```

3. Upload:

```bash
pip install twine
twine upload --repository testpypi dist/*
```

4. Manage secrets using `.env` and shell scripts (`run.sh`).

---

### 🔁 Automate with `run.sh`

Example flow:

```bash
./run.sh clean
./run.sh build
./run.sh publish:test
```

> ✅ Always increment version before re-publishing.

---

## ⚙️ Task Runners

### 🧱 Make

```bash
sudo apt-get install make
```

* Tab-indented file
* Shell-like syntax
* Efficient, portable, and reproducible

### 📦 Just

* Similar to `make`, but written in Rust
* Not as portable as Make

### 🐚 Bash Script Task Runner

Example:

```bash
chmod +x run.sh
./run.sh build
```

Use `echo $@` in scripts to display passed arguments.

---

## 🧠 Additional Learning Resources

* 🎙️ [Talk Python to Me Podcast](https://talkpython.fm/)
* 🔒 [Snyk – Python Security Tool](https://snyk.io)


