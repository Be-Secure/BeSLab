## Adding new tool module

1. Create a fork of [BeSlab](https://github.com/Be-Secure/BeSLab) to you namespace.

2. Clone the forked repository to local system. use

```shell
git clone https://github.com/<younamespace>/BeSLab.git
```

3. change directory to BeSLab.

4. Write the test case for the new plugin first.

5. Copy the template file from [docs/template/beslab_plugin_template.sh](https://github.com/Be-Secure/BeSLab/blob/master/docs/templates/beslab_plugin_template.sh) to src/besman-\<TOOLNAME>\.sh . replace TOOLNAME with the actual toolname. Keep the naming convention of tool plugin file consistent in format and small case letters only.

6. Update the function names in template file by replacing the \"toolname\" with the actual name of the tool considered.

7. Update the functions as per the tool. \(Please Follow the instructrions mentioned in template comments for each function.\)

8. Test the new module as per test cases written and verify the tool is working as expected.

9. Push the tested and passed code changes to your forked branch.

10. Raise a PR from your forked repository to BeSLab repository in Be-Seucure namespace.

Note: Do not raise PR request on main branch but use develop branch to raise PR for Be-Secure namespace.

11. Notify the maintainers for review. If required do the discussions for feature and modifications if any over email or discussions section.

12. Upon approval of the PR, merge the code to develop branch with all conflicts resolved.

CONGRATULATIONS!! your plugin is live now. Thanks for your contribution.
