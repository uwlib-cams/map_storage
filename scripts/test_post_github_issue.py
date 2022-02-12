from github import Github
import os
from pprint import pprint

# tutorial used: https://towardsdatascience.com/all-the-things-you-can-do-with-github-api-and-python-f01790fca131

os.environ['GITHUB_TOKEN'] = personal_access_token
token = os.getenv('GITHUB_TOKEN', '...')

g = Github(token)
repo = g.get_repo(github_user/repo_name)
i = repo.create_issue(
    title="Issue Title",
    body="Text of the body.",
    assignee=github_user,
    labels=[
        repo.get_label(label)
    ]
)
pprint(i)
