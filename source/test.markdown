A Guide to Testing Rails Applications
=====================================

This guide covers built-in mechanisms offered by Rails to test your application. By referring to this guide, you will be able to:

* Understand Rails testing terminology
* Write unit, functional and integration tests for your application
* Identify other popular testing approaches and plugins

This guide won't teach you to write a Rails application; it assumes
basic familiarity with the Rails way of doing things.

* * *

Why Write Tests for your Rails Applications?
--------------------------------------------

* Rails makes it super easy to write your tests. It starts by producing skeleton test code in background while you are creating your models and controllers.
* By simply running your Rails tests you can ensure your code adheres to the desired functionality even after some major code refactoring.
* Rails tests can also simulate browser requests and thus you can test your application's response without having to test it through your browser.

Introduction to Testing
-----------------------

Testing support was woven into the Rails fabric from the beginning. It wasn't an "oh! let's bolt on support for running tests because they're new and cool" epiphany. Just about every Rails application interacts heavily with a database - and, as a result, your tests will need a database to interact with as well. To write efficient tests, you'll need to understand how to set up this database and populate it with sample data.

The Three Environments
----------------------

Every Rails application you build has 3 sides: a side for production, a side for development, and a side for testing.

One place you'll find this distinction is in the +config/database.yml+ file. This YAML configuration file has 3 different sections defining 3 unique database setups:

* production
* development
* test

This allows you to set up and interact with test data without any danger of your tests altering data from your production environment.

For example, suppose you need to test your new +delete_this_user_and_every_everything_associated_with_it+ function. Wouldn't you want to run this in an environment where it makes no difference if you destroy data or not?

When you do end up destroying your testing database (and it will happen, trust me), you can rebuild it from scratch according to the specs defined in the development database. You can do this by running +rake db:test:prepare+.

### Rails Sets up for Testing from the Word Go

Rails creates a +test+ folder for you as soon as you create a Rails project using +rails _application_name_+. If you list the contents of this folder then you shall see:

    $ ls -F test/
    fixtures/       functional/     integration/    test_helper.rb    unit/
{:shell}

Here is some Ruby

    def foo
      puts 1
    end
{:ruby}
