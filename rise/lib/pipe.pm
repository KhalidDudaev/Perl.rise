{ package rise::lib; use rise::core::object::namespace;   

    { package rise::lib::portal;use rise::core::object::class;  __PACKAGE__->private_class("rise::lib", "rise::lib::portal");our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1204003026"; sub VERSION {"2016.1204003026"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __class__ { __PACKAGE__ } sub __CLASS_MEMBERS__ {q{export:simple-function-portal}} sub __EXPORT__ { {":all"=>[qw/portal/],":function"=>[qw/portal/],":simple"=>[qw/portal/],"portal"=>[qw/portal/],} } 

        { package rise::lib::portal::portal; use rise::core::object::function; sub __function__ { __PACKAGE__ }   sub portal {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = shift; my $args; no warnings; sub args ():lvalue; *args = sub ():lvalue { $args }; use warnings;  $args = \@_; my $a; no warnings; sub a ():lvalue; *a = sub ():lvalue { $a }; use warnings;  ($a) = ($_[0]); 
            $self ||= 'a';
            $a ||= 'b';
            # say "a -> $a";
            # say "b -> $b";
            return &{$a}($self);
        }}

        # sub UNIVERSAL::pipe {
        #     goto &pipe;
        # }

        sub UNIVERSAL::portal {
            goto &portal;
        }

    }

}

1;