using BinDeps
@static if VERSION <= v"0.7-"
	import Compat: Sys
end

@BinDeps.setup

const libui = library_dependency("libui")
const libuiVer = "4"
const libuiFilebase = "alpha$(libuiVer)"

const prefix = joinpath(BinDeps.depsdir(libui), "usr")

provides(Sources,
         URI("http://w3.ualg.pt/%7Ejluis/t/$(libuiFilebase).tar.gz"),
         libui)

const prefix = joinpath(BinDeps.depsdir(libui), "usr")

const srcpath = if Sys.islinux()
    joinpath(BinDeps.srcdir(libui), libuiFilebase, "linux_amd64", "shared", "libui.so.0")
elseif Sys.isapple()
    joinpath(BinDeps.srcdir(libui), libuiFilebase, "darwin_amd64", "shared", "libui.A.dylib")
elseif Sys.iswindows() #TODO: Check this on a CI service
    joinpath(BinDeps.srcdir(libui), libuiFilebase, "windows_amd64", "shared", "libui.dll")
else
    error("Platform not supported.")
end

const binaryNameTarget = if Sys.islinux()
	"libui.so"
elseif Sys.isapple()
	"libui.dylib"
elseif Sys.iswindows()
	"libui.dll"
else
	error("Platform not supported.")
end

provides(SimpleBuild,
		 (@build_steps begin
		  GetSources(libui)
		  CreateDirectory(joinpath(prefix, "lib"))
		  `cp -v $(srcpath) $(joinpath(prefix, "lib", binaryNameTarget))`
		  end
		  ), libui)

@BinDeps.install Dict(:libui => :libui)
