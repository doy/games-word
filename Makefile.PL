# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'Games-Word';
all_from       'lib/Games/Word.pm';

requires       'Math::Combinatorics';
requires       'Test::Deep::NoTest';
requires       'List::MoreUtils';

build_requires 'Test::More';
build_requires 'Test::Exception';
build_requires 'Test::Deep';

auto_install;
WriteAll;

