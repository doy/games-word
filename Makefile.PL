# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'Games-Word';
all_from       'lib/Games/Word.pm';

requires       '';

build_requires 'Test::More';

auto_install;
WriteAll;

