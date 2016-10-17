{ package rise::lib::tman::plugin; use rise::core::object::namespace;   
	{ package rise::lib::tman::plugin::copy; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1017044311"; sub VERSION {"2016.1017044311"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-copy}} 
        { package rise::lib::tman::plugin::copy::copy; use rise::core::object::function;  sub copy {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings;  ($self,$path) = ($_[0],$_[1]); 



            if ($self->dst_name) {
                # say ">>> " ~ path;
                # self.dst_path		= path;
                #
                my $dpath; no warnings; sub dpath ():lvalue; *dpath = sub ():lvalue { $dpath }; use warnings;  $dpath = $path . $self->referPath();
                my $err; no warnings; sub err ():lvalue; *err = sub ():lvalue { $err }; use warnings;  $err = '';
                #
                if(!$self->fs->info->isDir($dpath)){
                    mkdir $dpath or $err = "ERROR: Cant make dir $dpath";
                    if ($err) {
                        say $err;
                        $self->sndERR();
                        return;
                    }
                    # say "mkdir $dpath";
                }
                #
                # self.code_res		= self.code_src;
                # self.dst_ext		= self.fs.path.ext(self.src_name);
                my $dst_name; no warnings; sub dst_name ():lvalue; *dst_name = sub ():lvalue { $dst_name }; use warnings;  $dst_name = $dpath . $self->basename . '.' . $self->dst_ext;
                # self.fs.file.write(dst_name, self.code_res) if self.code_res;
                $self->fs->file->copy($self->dst_name, $dst_name);

                $self->sndOK();
            }
            # self.snd.play(self.snd_OK);
            return $self;
        }}

        # function referPath () {
		# 	var spath			= self.src_path;
		# 	spath               =~ s{^([^\*]*).*?$}{$1}sx;
		# 	var (ref_path)		= self.src_name =~ m{^$spath(.*?)$}sx;
		# 	self.ref_path		= self.fs.path.path(ref_path);
		# 	return self.ref_path;
		# }
	}
}

1;