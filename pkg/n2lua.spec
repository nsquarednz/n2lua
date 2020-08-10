Name: %(echo $PACKAGE)
Version: %(echo $VERSION)
Release: %(echo $RELEASE)
Summary: Powerful light-weight programming language
Group: Development/Languages/C and C++
License: MIT
URL: http://www.lua.org/
BuildArch: x86_64
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%global n2luaRoot /opt/%{name}
%global _binaries_in_noarch_packages_terminate_build 0

%description
N-Squared Software fork of V5.2.x of the LUA scripting language.

%post

# Check if we have previously installed a Dynaloader configuration file. If not we need to insert our template.
if [ ! -e /etc/ld.so.conf.d/liblua.conf ]; then
    cp /opt/%{name}/etc/liblua.conf /etc/ld.so.conf.d/liblua.conf
    echo "Copied in /etc/ld.so.conf.d/liblua.conf reloading Dynaloader indexes..."
    ldconfig
    echo "Successfully reloaded Dynaloader indexes."    
fi

%prep

#
# All build steps are done by build-packages.sh.
#

%build

#
# All build steps are done by build-packages.sh.
#

%install

rm -rf %{buildroot}
mkdir -p %{buildroot}/opt/%{name}
cp -r %{_builddir}/* %{buildroot}/opt/%{name}

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{n2luaRoot}

%changelog
