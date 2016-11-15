{ package rise::lib::fs; use rise::core::object::namespace;   
    { package rise::lib::fs::path; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1114205141"; sub VERSION {"2016.1114205141"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-cwd  public-function-toAbs  public-function-toRel  public-function-isAbs  public-function-isRel  public-function-path  public-function-filename  public-function-basename  public-function-ext}} 
        use Cwd;

        # public var slash          = '/';

        { package rise::lib::fs::path::cwd; use rise::core::object::function;  sub cwd {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_;  
            my $cwdir; no warnings; sub cwdir ():lvalue; *cwdir = sub ():lvalue { $cwdir }; use warnings;  $cwdir = Cwd::abs_path();
             my $slash; no warnings; sub slash ():lvalue; *slash = sub ():lvalue { $slash }; use warnings;  ($slash) = __RISE_MATCH $cwdir =~ m{(\\|\/)}sx;
            $cwdir .= $slash;
            # (cwdir) = toList cwdir =~ m{^(.*?)[^\\\/]*$}sx;
            # say '>>>' ~ cwdir ~ '<<<';
            return $cwdir;
        }}

        { package rise::lib::fs::path::toAbs; use rise::core::object::function;  sub toAbs {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($fname) = ($_[0]);
            $fname = $self->cwd . $fname if $self->isRel($fname);
            return $fname;
        }}

        { package rise::lib::fs::path::toRel; use rise::core::object::function;  sub toRel {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($fname) = ($_[0]);
            my $cwdir; no warnings; sub cwdir ():lvalue; *cwdir = sub ():lvalue { $cwdir }; use warnings;  $cwdir = $self->cwd;
            $cwdir =~ s{\\}{\\\\}gsx;
            $fname =~ s{$cwdir}{}sx;
            # fname =~ replace:sx cwdir => "";
            return $fname;
        }}

        { package rise::lib::fs::path::isAbs; use rise::core::object::function;  sub isAbs {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($fname) = ($_[0]);
            return __RISE_MATCH $fname =~ m{^(?:\w+\:|[\W]+)};
        }}

        { package rise::lib::fs::path::isRel; use rise::core::object::function;  sub isRel {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($fname) = ($_[0]);
            return __RISE_MATCH $fname !~ m{^(?:\w+\:|[\W]+)};
        }}

        { package rise::lib::fs::path::path; use rise::core::object::function;  sub path {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($fname) = ($_[0]); 
             my $p; no warnings; sub p ():lvalue; *p = sub ():lvalue { $p }; use warnings;  ($p) = __RISE_MATCH $fname =~ m{^(.*?)[^\\\/]*$}sx;
            return $p;
        }}

        { package rise::lib::fs::path::filename; use rise::core::object::function;  sub filename {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($fname) = ($_[0]);
            $fname      =~ s{^.*?([^\\\/]*)$}{$1}sx;
            return $fname;
        }}

        { package rise::lib::fs::path::basename; use rise::core::object::function;  sub basename {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($fname) = ($_[0]);
            $fname      =~ s{^.*?(\w+(?:\.\w+)*)$}{$1}sx;
            $fname      =~ s{^(.*?)(?:\.(\w+))?$}{$1}sx;
            return $fname;
        }}

        { package rise::lib::fs::path::ext; use rise::core::object::function;  sub ext {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $fname; no warnings; sub fname ():lvalue; *fname = sub ():lvalue { $fname }; use warnings;  ($fname) = ($_[0]);
            $fname      =~ s{^.*?(\w+(?:\.\w+)*)$}{$1}sx;
            $fname      =~ s{^(.*?)(?:\.(\w+))?$}{$2||''}sxe;
            return $fname;
        }}

        # public function isFile (name) { -e name && !-d _ }
        # public function isDir  (name) { -d name }
    }
}

1;