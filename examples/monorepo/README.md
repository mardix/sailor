# Polybox

This is an example of a mono repo, where Polybox can deploy multiple apps from the same repo

It uses Express/Node, Flask/Python to build both app

---

## Set up GIT remote

```
# Setup the node remote
git remote add polybox-node polybox@YOUR-HOST:node-app

# Setup the Python remote
git remote add polybox-py polybox@YOUR-HOST:python-app

```

## GIT Push to deploy

```
git push polybox-node master

git push polybox-py master
```

---

Licence MIT