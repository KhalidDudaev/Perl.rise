#ksdfkjs
{ package rise::lib::tman::plugin; use rise::core::object::namespace;   
	{ package rise::lib::tman::plugin::copy; use rise::core::object::class;  our $AUTHORITY = "unknown"; sub AUTHORITY {"unknown"}; our $VERSION = "2016.1105052847"; sub VERSION {"2016.1105052847"}; my $__RISE_SELF__ = bless {}; sub __RISE_SELF__ ():lvalue { $__RISE_SELF__ } sub __CLASS_MEMBERS__ {q{public-function-plugin}} 
        { package rise::lib::tman::plugin::copy::plugin; use rise::core::object::function;  sub plugin {  my $self; no warnings; sub self ():lvalue; *self = sub ():lvalue { $self }; use warnings;  $self = $_[0]; my $path; no warnings; sub path ():lvalue; *path = sub ():lvalue { $path }; use warnings;  ($path) = ($_[1]); 

            my $dpath; no warnings; sub dpath ():lvalue; *dpath = sub ():lvalue { $dpath }; use warnings;  $dpath = $path . $self->referPath();
            my $err; no warnings; sub err ():lvalue; *err = sub ():lvalue { $err }; use warnings;  $err = '';
            #
            # say ">>> copy dir " ~ dpath;
            if(!$self->fs->info->isDir($dpath)){
                mkdir $dpath or $err = "ERROR: Cant make dir $dpath";
                if ($err) {
                    say $err;
                    $self->sndERR();
                    return;
                }
                # say "mkdir $dpath";
            }

    		$self->filename		= $self->fs->path->filename($self->src_name);
            $self->dst_file		= $self->filename;
            $self->dst_name		= $dpath . $self->filename;
            # self.fs.file.write(dst_name, self.code_res) if self.code_res;
            $self->fs->file->copy($self->src_name, $self->dst_name);

            $self->sndOK();
            # }
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