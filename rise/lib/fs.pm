{ package rise::lib; use rise::core::object::namespace;   
    { package rise::lib::fs; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1204003026"; sub VERSION {"2016.1204003026"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { __PACKAGE__ } sub __CLASS_MEMBERS__ {q{}} 

        use rise::lib::fs::path;
        use rise::lib::fs::dir;
        use rise::lib::fs::file;
        use rise::lib::fs::info;

         sub dir ():lvalue; *__dir__ = sub ():lvalue {  my $self = shift; $self->{'dir'} }; *dir = sub ():lvalue {  $__RISE_SELF__->{'dir'} };   dir = new rise::lib::fs::dir::;
         sub path ():lvalue; *__path__ = sub ():lvalue {  my $self = shift; $self->{'path'} }; *path = sub ():lvalue {  $__RISE_SELF__->{'path'} };   path = new rise::lib::fs::path::;
         sub file ():lvalue; *__file__ = sub ():lvalue {  my $self = shift; $self->{'file'} }; *file = sub ():lvalue {  $__RISE_SELF__->{'file'} };   file = new rise::lib::fs::file::;
         sub info ():lvalue; *__info__ = sub ():lvalue {  my $self = shift; $self->{'info'} }; *info = sub ():lvalue {  $__RISE_SELF__->{'info'} };   info = new rise::lib::fs::info::;

    }
}

1;