#!perl                                                      #  make sure to fix
use Test::More 0.88;                                        #  line numbers
                                                            #  for any line
                                                            #  identified
use B qw(class);                                            #  as an op!
use B::Utils qw( all_roots walkoptree_simple);

my @lines = ();                                             #  8  op
my $callback = sub
{
  my $op = shift;
  if ('COP' eq B::class($op) and  $op->file eq __FILE__) {
    push @lines, $op->line unless $op->name eq 'null';
  }
};                                                          # 15  op

foreach my $op (values %{all_roots()}) {                    # 17  op
  walkoptree_simple( $op, $callback );                      # 18  op
}
my $expected = [8, 15, 17, 18, 20, 22, 25, 29, 34, 40];     # 20  op

if ("$]" < 5.045003) {                                      # 22  op
  $expected =  [8, 15, 17, 18, 20, 22, 25, 29, 34, 37, 40];
}
if ("$]" < 5.007) {                                         # 25  op
  $expected =  [8, 15, 17, 18, 17, 20, 22, 25, 29, 34, 37, 40];
}

is_deeply(\@lines,                                          # 29  op
          $expected,
          'walkoptree_simple lines of ' . __FILE__);

# For testing following if/else in code.
if (@lines) {                                               # 34  op
  ok(1);     # FIXME: This line isn't coming out.
} else {
  ok(0);                                                    # 37  op
}

done_testing();                                             # 40  op
__END__
diag join(', ', @lines), "\n";
