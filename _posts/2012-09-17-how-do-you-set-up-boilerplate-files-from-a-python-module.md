---
title: How do you set up boilerplate files from a python module?
date: 2012-09-17
---

Django is loaded with Python goodness. Whenever I have a particular problem, its code is usually the first place I look. Over the last month, I have been working on a project to automate some of the required forms I need to fill out during my day job. My design required setting up a couple of predefined files in the current directory. Django has a command called `django-admin.py` that sets up an entire directory structure for you by doing one simple command:

	django-admin.py startproject my_project

`django-admin.py` is the program name (and is actually just a five-line wrapper), with a subcommand "startproject" and the directory argument "my_project". This results in the following directory structure:

    adam@Light[~]
    $ django-admin.py startproject my_project

    adam@Light[~]
    $ ls my_project/*
    my_project/manage.py

    my_project/my_project:
    __init__.py settings.py urls.py     wsgi.py

The built-in subcommands are stored in `django/core/management/commands`. Here are the relevant bits from `startproject.py`:

    from django.core.management.base import CommandError
    from django.core.management.templates import TemplateCommand

    class Command(TemplateCommand):
        help = ("Creates a Django project directory structure for the given "
                "project name in the current directory or optionally in the "
                "given directory.")

        def handle(self, project_name=None, target=None, *args, **options):
            if project_name is None:
                raise CommandError("you must provide a project name")

            #[...] Check that the project hasn't already been created, set up a random SECRET_KEY

            super(Command, self).handle('project', project_name, target, **options)

The class `Command` is descended from `TemplateCommand`, and it seems that the brunt of the work is being handled by passing it to a method `handle` with the first argument 'project'. Upon further inspection, it uses the string 'project' to pull files from `django/conf/project_template'. Sure enough, we see a very familiar structure.

    adam@Light[~/software/programming/django/django/conf]
    $ ls project_template/*
    project_template/manage.py

    project_template/project_name:
    __init__.py settings.py urls.py     wsgi.py

Lastly, we see that `TemplateCommand.handle()` is replacing 'project_name' with the folder name passed in (lines removed for brevity):

    def handle(self, app_or_project, name, target=None, **options):
        base_name = '%s_name' % app_or_project

        for root, dirs, files in os.walk(template_dir):
            path_rest = root[prefix_length:]
            relative_dir = path_rest.replace(base_name, name)
            if relative_dir:
                target_dir = path.join(top_dir, relative_dir)
                if not path.exists(target_dir):
                    os.mkdir(target_dir)

            for filename in files:
                if filename.endswith(('.pyo', '.pyc', '.py.class')):
                    # Ignore some files as they cause various breakages.
                    continue
                old_path = path.join(root, filename)
                new_path = path.join(top_dir, relative_dir,
                                     filename.replace(base_name, name))
                try:
                    shutil.copymode(old_path, new_path)
                    self.make_writeable(new_path)
                except OSError:
                    self.stderr.write(
                        "Notice: Couldn't set permission bits on %s. You're "
                        "probably using an uncommon filesystem setup. No "
                        "problem." % new_path, self.style.NOTICE)

With all that said, the procedure seems relatively simple:

1. Store the files you'd like to set up in the package under a known name and location.
2. Loop through the location, replacing the known name with the specified one and create all directories.
3. Copy all files held within.

