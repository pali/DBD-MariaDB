use strict;
use warnings;

use DBI;
use Test::More;

$|= 1;

use vars qw($test_dsn $test_user $test_password);
use lib 't', '.';
require 'lib.pl';

# yes, we will reconnect, but I want to keep the "fail if not connect"
# separate from the actual test where we reconnect
my $dbh = DbiTestConnect($test_dsn, $test_user, $test_password,
                      { RaiseError => 1, PrintError => 0 });
plan tests => 6;

for my $ur (0,1) {
    $test_dsn .= ";mariadb_use_result=1" if $ur;
    # reconnect
    ok ($dbh->disconnect());
    ok ($dbh= DBI->connect($test_dsn, $test_user, $test_password,
                      { RaiseError => 1, PrintError => 0, AutoCommit => 0 }));
    cmp_ok $dbh->{mariadb_use_result}, '==', $ur, "mariadb_use_result set to $ur";
}
