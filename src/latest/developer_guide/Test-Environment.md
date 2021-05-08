# Test Environment

For automated testing dotNetRDF uses a combination of NUnit based unit tests and manual test harnesses. We also do manual testing for the UI tools in our toolkit as we develop new features for those tools. This document details the various test harnesses available and how to run them.

We use the free CI/CD hosting graciously provided by [AppVeyor](https://www.appveyor.com) to host the [CI build and test of dotNetRDF](https://ci.appveyor.com/project/dotNetRDFadmin/dotnetrdf).

## Unit Tests

The Unit Tests are contained in a project called `dotNetRDF.Test` found in the `Testing/unittest/` folder of our source code and within the solution when opened in Visual Studio. Before you can run the unit tests there is something you must do which is to configure the unit test environment.

When you first build the unit tests from a source download/checkout it will generate a file called `UnitTestConfig.properties` in the `resources/` directory of the unit tests. This is based off of the `UnitTestConfig.template` file in the same directory.  This file can be edited to indicate whether the external features that some tests rely upon are actually available in your environment and configure them appropriately. This file uses a simple Java properties style format for defining settings so should be self explanatory to edit

When you run tests those that require features marked as unavailable the tests will be marked as Ignored rather than Failed. This allows you to easily distinguish between tests that failed and tests that cannot be run in your environment.

Assuming that you do not change the config from the template running the tests will yield approximately 200 or so ignored tests. The exact number may vary depending on your environment and whether you have configured any of the external features as available in your environment.

### Intermittent Failures

You may find that a few tests fail, some of these may be genuine failures while a few are intermittent failures. We suggest attempting to run the failing tests again at least once because sometimes this will resolve intermittent failures.

Some of these intermittent failures are down to tests that rely upon web based resources such as [DBPedia](http://dbpedia.org) which may be temporarily unavailable or over capacity at the time of running the tests.  Others relate to timeout tests are may fail simply because your system is powerful enough to finish the tested task before the timeout is hit or conversely is too slow to run the test within the timeout.

### Genuine Failures

Depending on the current state of Trunk when you run the tests you may find that there are some genuine failures because there are tests in place for reported bugs that are unresolved or new features that are incomplete.  If you think you have encountered this check the recent commit messages or simply ask on the developer mailing list

## Bugs, Tests and Patches

When you find a bug it makes it much easier for us to debug and fix if you can provide a unit test that illustrates this bug. When you create a unit test please try to follow our naming convention which a Pascal case style naming where names start with a term that refers to the general area the test applies to (e.g. Sparql) and then contain one or more terms further describing the specific functionality the test is testing.

So an example name might be `SparqlDatasetDefaultGraphUnion`

If you also develop a patch you will likely want to run more tests than just the ones you created in order to validate that your patch did not cause regressions elsewhere. If the patch is fairly well isolated in relation to your bug then you should typically only need to run the general functional area tests e.g. if you are writing a patch for a parsing problem just run the tests whose names begin Parsing

If your patch is not well isolated or you've changed something where you aren't sure of the full ramifications of your change then you should run all the tests. If you see significant failures that aren't resolved by running the failing tests again (and thus ruling out intermittent failures) then you can still submit your patch but please clearly state that your patch may cause other failures. In some cases the other failures may be that other tests were silently assuming the existing bug without being aware of it but in other cases they may be due to a regression your patch introduces. If you can't figure out this yourself please tell us that this is the case so we can take a more detailed look.

## SPARQL DAWG Testing

There is a standalone executable that can be used to run the official SPARQL DAWG test suite to check for SPARQL compliance. It is important to run this anytime you make any change to the SPARQL engine or code related to it. This executable spits out two logs files detailing compliance with SPARQL 1.0 and SPARQL 1.1 - see the end of the file for a summary of the results.

Currently there are 1 failures expected in the 1.0 suite which relate to URI normalization issues which we cannot workaround due to our use of the .Net `Uri` class and there should be no 1.1 failures.