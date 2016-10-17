{ package rise::lib::fs; use rise::core::object::namespace;   
    { package rise::lib::fs::info; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1017055954"; sub VERSION {"2016.1017055954"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-dev  public-function-ino  public-function-mode  public-function-nlink  public-function-uid  public-function-gid  public-function-rdev  public-function-size  public-function-atime  public-function-mtime  public-function-ctime  public-function-blksize  public-function-blocks  public-function-isFile  public-function-isDir}} 

        { package rise::lib::fs::info::dev; use rise::core::object::function;  sub dev {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[0];
        }}
        { package rise::lib::fs::info::ino; use rise::core::object::function;  sub ino {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[1];
        }}
        { package rise::lib::fs::info::mode; use rise::core::object::function;  sub mode {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[2];
        }}
        { package rise::lib::fs::info::nlink; use rise::core::object::function;  sub nlink {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[3];
        }}
        { package rise::lib::fs::info::uid; use rise::core::object::function;  sub uid {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[4];
        }}
        { package rise::lib::fs::info::gid; use rise::core::object::function;  sub gid {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[5];
        }}
        { package rise::lib::fs::info::rdev; use rise::core::object::function;  sub rdev {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[6];
        }}
        { package rise::lib::fs::info::size; use rise::core::object::function; no warnings qw/redefine prototype/;  sub size  {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[7];
        }}
        { package rise::lib::fs::info::atime; use rise::core::object::function;  sub atime {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[8];
        }}
        { package rise::lib::fs::info::mtime; use rise::core::object::function;  sub mtime {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[9];
        }}
        { package rise::lib::fs::info::ctime; use rise::core::object::function;  sub ctime {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[10];
        }}
        { package rise::lib::fs::info::blksize; use rise::core::object::function;  sub blksize {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[11];
        }}
        { package rise::lib::fs::info::blocks; use rise::core::object::function;  sub blocks {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($self,$fname) = ($_[0],$_[1]); 
            return (stat($fname))[12];
        }}
        { package rise::lib::fs::info::isFile; use rise::core::object::function;  sub isFile {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name; no warnings; sub name ():lvalue; *name = sub ():lvalue { $name }; use warnings;  ($self,$name) = ($_[0],$_[1]);  -e $name && !-d _ }}
        { package rise::lib::fs::info::isDir; use rise::core::object::function;  sub isDir {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $name; no warnings; sub name ():lvalue; *name = sub ():lvalue { $name }; use warnings;  ($self,$name) = ($_[0],$_[1]);   -d $name }}
    }

}

1;