{ package rise::lib; use rise::core::object::namespace;   
    { package rise::lib::fs; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1114205141"; sub VERSION {"2016.1114205141"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{}} 

        use rise::lib::fs::path;
        use rise::lib::fs::dir;
        use rise::lib::fs::file;
        use rise::lib::fs::info;

         sub dir ():lvalue; no warnings; *__dir__ = sub ():lvalue {  my $self = shift; $self->{'dir'} }; *dir = sub ():lvalue {  $__RISE_SELF__->{'dir'} }; use warnings;  dir = new rise::lib::fs::dir::;
         sub path ():lvalue; no warnings; *__path__ = sub ():lvalue {  my $self = shift; $self->{'path'} }; *path = sub ():lvalue {  $__RISE_SELF__->{'path'} }; use warnings;  path = new rise::lib::fs::path::;
         sub file ():lvalue; no warnings; *__file__ = sub ():lvalue {  my $self = shift; $self->{'file'} }; *file = sub ():lvalue {  $__RISE_SELF__->{'file'} }; use warnings;  file = new rise::lib::fs::file::;
         sub info ():lvalue; no warnings; *__info__ = sub ():lvalue {  my $self = shift; $self->{'info'} }; *info = sub ():lvalue {  $__RISE_SELF__->{'info'} }; use warnings;  info = new rise::lib::fs::info::;

    }
}

1;