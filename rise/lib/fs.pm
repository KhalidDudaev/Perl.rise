{ package rise::lib; use rise::core::object::namespace;   
    { package rise::lib::fs; use rise::core::object::class;  

        use rise::lib::fs::pathWorker;
        use rise::lib::fs::dirWorker;
        use rise::lib::fs::fileWorker;
        use rise::lib::fs::infoWorker;

        my $dir; no warnings; sub dir ():lvalue; *dir = sub ():lvalue {  $dir }; use warnings;  $dir = new rise::lib::fs::dirWorker;
        my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue {  $path }; use warnings;  $path = new rise::lib::fs::pathWorker;
        my $file; no warnings; sub file ():lvalue; *file = sub ():lvalue {  $file }; use warnings;  $file = new rise::lib::fs::fileWorker;
        my $info; no warnings; sub info ():lvalue; *info = sub ():lvalue {  $info }; use warnings;  $info = new rise::lib::fs::infoWorker;

    }
}

1;