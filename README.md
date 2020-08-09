# N2LUA
Copy of the latest 5.2.x branch of the LUA scripting library with associated packaging scripts to generate RPM built packages for RHEL, CentOS and Oracle Linux platforms.

To build an RPM package for a target system the RPM must be build on the target environment that the package will be deployed on as the LUA compilation step happens at build time, one of our Docker build environments is highly recommended.

`cd pkg`
`./build-packages.sh x.x.x x`
