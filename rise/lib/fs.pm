{ package rise::lib; use rise::core::object::namespace;   
    { package rise::lib::fs; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.0929003752"; sub VERSION {"2016.0929003752"}; my $__CLASS_SELF__ = bless {};  

        use rise::lib::fs::pathWorker;
        use rise::lib::fs::dirWorker;
        use rise::lib::fs::fileWorker;
        use rise::lib::fs::infoWorker;

         sub dir ():lvalue; no warnings; *dir = sub ():lvalue { no strict;  my $self = shift || $__CLASS_SELF__; $self->{'dir'} ||= $__CLASS_SELF__->{'dir'}; $self->{'dir'} }; use warnings;  dir = new rise::lib::fs::dirWorker;
         sub path ():lvalue; no warnings; *path = sub ():lvalue { no strict;  my $self = shift || $__CLASS_SELF__; $self->{'path'} ||= $__CLASS_SELF__->{'path'}; $self->{'path'} }; use warnings;  path = new rise::lib::fs::pathWorker;
         sub file ():lvalue; no warnings; *file = sub ():lvalue { no strict;  my $self = shift || $__CLASS_SELF__; $self->{'file'} ||= $__CLASS_SELF__->{'file'}; $self->{'file'} }; use warnings;  file = new rise::lib::fs::fileWorker;
         sub info ():lvalue; no warnings; *info = sub ():lvalue { no strict;  my $self = shift || $__CLASS_SELF__; $self->{'info'} ||= $__CLASS_SELF__->{'info'}; $self->{'info'} }; use warnings;  info = new rise::lib::fs::infoWorker;

    }
}

1;