ifdef OS
   export PYTHON_COMMAND=python
else
   export PYTHON_COMMAND=python3.12
endif


setup:
	$(PYTHON_COMMAND) -m pip install poetry
	poetry env use $(PYTHON_COMMAND)
	poetry run pip install --upgrade pip

install:
	poetry lock
	poetry install

isort:
	poetry run isort --skip-glob=.tox .

format:
	poetry run black safecrew

lint:
	make isort
	make format
	poetry run pylint  --extension-pkg-whitelist='pydantic' safecrew
	poetry run flake8 experiments
	poetry run mypy --ignore-missing-imports --install-types --non-interactive --package safecrew

test:
	poetry run pytest --verbose --color=yes --cov=safecrew

env:
	poetry shell

requirements:
	poetry export --without-hashes --with-credentials -f requirements.txt

minimum-requirements:
	poetry export --without-hashes --with-credentials -f requirements.txt | grep -e ml3-repo-manager -e pyyaml -e -- > requirements.txt

clean_notebook_outputs:
	find safecrew/milan -name "*.ipynb" -type f | xargs -I {} poetry run jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace {}
	@echo "Notebook outputs have been cleared successfully."
