{ package rise::lib; use rise::core::object::namespace;   
    { package rise::lib::fs; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1016042911"; sub VERSION {"2016.1016042911"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{}} 

        use rise::lib::fs::pathWorker;
        use rise::lib::fs::dirWorker;
        use rise::lib::fs::fileWorker;
        use rise::lib::fs::infoWorker;

         sub dir ():lvalue; no warnings; *__dir__ = sub ():lvalue {  my $self = shift; $self->{'dir'} }; *dir = sub ():lvalue {  $__RISE_SELF__->{'dir'} }; use warnings;  dir = new rise::lib::fs::dirWorker::;
         sub path ():lvalue; no warnings; *__path__ = sub ():lvalue {  my $self = shift; $self->{'path'} }; *path = sub ():lvalue {  $__RISE_SELF__->{'path'} }; use warnings;  path = new rise::lib::fs::pathWorker::;
         sub file ():lvalue; no warnings; *__file__ = sub ():lvalue {  my $self = shift; $self->{'file'} }; *file = sub ():lvalue {  $__RISE_SELF__->{'file'} }; use warnings;  file = new rise::lib::fs::fileWorker::;
         sub info ():lvalue; no warnings; *__info__ = sub ():lvalue {  my $self = shift; $self->{'info'} }; *info = sub ():lvalue {  $__RISE_SELF__->{'info'} }; use warnings;  info = new rise::lib::fs::infoWorker::;

    }
}

1;