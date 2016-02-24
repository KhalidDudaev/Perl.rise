{ package rise::lib; use rise::core::object::namespace;   

    { package rise::lib::pipe;use rise::core::object::class;  __PACKAGE__->private_class("rise::lib", "rise::lib::pipe"); sub __EXPORT__ { {":all"=>[qw/portal/],":function"=>[qw/portal/],":simple"=>[qw/portal/],"portal"=>[qw/portal/],} }

        { package rise::lib::pipe::portal; use rise::core::object::function; sub portal {  my $self; no warnings; local *self; sub self ():lvalue; *self = sub ():lvalue {  $self }; use warnings; my $a; no warnings; local *a; sub a ():lvalue; *a = sub ():lvalue {  $a }; use warnings;  ($self,$a) = ($_[0],$_[1]); 
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