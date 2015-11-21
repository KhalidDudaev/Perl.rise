{ package rise::lib;  use strict; use warnings;   
    { package rise::lib::fs; use strict; use warnings; use rise::core::ops::extends 'rise::core::object::class','rise::lib';   sub super { $rise::lib::fs::ISA[1] } my $self = 'rise::lib::fs'; sub self { $self }; BEGIN { __PACKAGE__->__RISE_COMMANDS } __PACKAGE__->interface_confirm; sub __OBJLIST__ {'public-var-dir public-var-path public-var-file'}
        use rise::lib::fs::pathWorker;
        use rise::lib::fs::dirWorker;
        use rise::lib::fs::fileWorker;

        my $dir; no warnings; sub dir ():lvalue; *dir = sub ():lvalue {  $dir }; use warnings;  $dir = new rise::lib::fs::dirWorker;
        my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue {  $path }; use warnings;  $path = new rise::lib::fs::pathWorker;
        my $file; no warnings; sub file ():lvalue; *file = sub ():lvalue {  $file }; use warnings;  $file = new rise::lib::fs::fileWorker;
    }
}

1;
