<!--Multi-tasks can be used to introduce a process where each child task is required, or to group a set of similar tasks.-->

## <# TITLE -- Insert an imperative phrase that describes the parent task, like "Upgrade a split installation". #>

<# SHORTDESC -- Insert a 1-2 sentence description of the parent task’s purpose. #>

<# CONTEXT (optional) -- Indicate whether the child tasks are required or optional. For example, “To upgrade a split installation, complete the following tasks in order” (required), or “The process for installing the client varies by platform” (optional, where each child task describes the process for a different platform). If you include a prereq, it can be helpful to list the child tasks and include links, because they don’t immediately follow the context. #>

<# PREREQ (optional) -- Insert imperative statements, preceded by "Before you begin:", describing high-level tasks the user must complete before performing this task or process. For example, "Before you begin: Review [upgrade requirements](<link>)." In a multi-task process, include only those prereqs that affect the entire procedure. #>


### <# TITLE -- Insert an imperative phrase that describes the subtask. For example, "Upgrade the Puppet master". #>

<# SHORTDESC -- Insert a 1-2 sentence description of the subtask’s purpose. #>

<# CONTEXT (optional) -- If the short description doesn’t provide enough background about the subtask, insert an additional paragraph to provide more context. #>

<# PREREQ (optional) -- Insert imperative statements, preceded by "Before you begin:", describing tasks the user must complete before performing this subtask. For example, "Before you begin: If you configured any PE settings using a Hiera `datadir` saved in a custom location, transfer these settings to `pe.conf`." #>

1. <# IMPERATIVE COMMAND #>

2. <# IMPERATIVE COMMAND WITH SCREENSHOT
   ![<IMAGE TITLE>](./images/<FILENAME.PNG>) #>

3. <# IMPERATIVE COMMAND WITH NOTE
   On a new, indented line, insert important information about a step, preceded with a note, caution, tip, important, remember, or restriction label. For example, "**Note:** You need about 1GB of space in `/tmp` to unpack the installer tarball." #>

4. <# IMPERATIVE COMMAND WITH INFO
   On a new, indented line, provide additional information about a step. For example, "PE opens your text editor with an example `pe.conf` file containing the parameters needed to perform a basic upgrade." #>

5. <# IMPERATIVE COMMAND WITH RESULTS
   On a new, indented line, tell users how they can confirm a step is complete, if necessary. For example, "When you save the file, the upgrader runs automatically." #>

6. <# IMPERATIVE COMMAND WITH SUBSTEPS
   1. SUBSTEP ONE
   2. SUBSTEP TWO
   3. SUBSTEP THREE #>

7. <# IMPERATIVE COMMAND WITH CHOICES -- Describe user action that depends on a variable, with the choices displayed in an unordered list. For example, "Run one of these commands, depending on <DECIDING FACTOR>:"
   - <CHOICE ONE> -- ...
   - <CHOICE TWO> -- ... #>


### <# TITLE -- Insert an imperative phrase that describes the subtask. For example, "Upgrade PuppetDB". #>

<# SHORTDESC -- Insert a 1-2 sentence description of the subtask’s purpose. #>

<# CONTEXT (optional) -- If the short description doesn’t provide enough background about the subtask, insert an additional paragraph to provide more context. #>

<# PREREQ (optional) -- Insert imperative statements, preceded by "Before you begin:", describing tasks the user must complete before performing this subtask. *Do* include previous subtasks in a multi-task process. For example, "Before you begin: [Upgrade the Puppet master](#upgrade-the-puppet-master)." #>

1. <# IMPERATIVE COMMAND #>


<!--Insert additional tasks as needed.-->


* * *
