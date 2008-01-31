# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'Games-Word';
all_from       'lib/Games/Word.pm';

requires       'Math::Combinatorics';
requires       'Test::Deep::NoTest';

build_requires 'Test::More';
build_requires 'Test::Exception';

auto_install;
WriteAll;

