---
description: SAML / Shibboleth Plugin Installation
---

# SAML / Shibboleth Plugin Installation

## Introduction

#### SAML Introduction

Combined authentication and authorization processes are streamlined by SAML for users, identity providers, and service providers. In order to allow the identity provider and service providers to operate independently from each other, SAML offers a solution that centralises user management and grants access to Restyaboard.

#### What is SAML Used For?

SAML implements a secure method of passing user authentications and authorizations between the identity provider and service providers. When a user logs into a SAML enabled application, the service provider requests authorization from the appropriate identity provider. The identity provider authenticates the user’s credentials and then returns the authorization.

#### Shibboleth Introduction

Shibboleth is a web-based Single Sign-On infrastructure. It is based on SAML, a standard for the exchange of authentication data.

Shibboleth allows one to authenticate using a local institutional service (IdP) to gain access to remote resources and services (SPs).

#### SAML / Shibboleth Uses

SAML allows users the ability to safely access several applications with a single set of once-entered credentials. It is the basis of the federation and the single sign-on as well (SSO). Using SAML, users can access numerous applications simultaneously enabling them to conduct business more easily and more effectively.

Shibboleth links to existing enterprise identity and authentication management systems such as Active Directory, CAS, LDAP, SQL, NTLM, Kerberos, SPNEGO, and others. It decreases the adoption hurdles.

## Video Tutorial

For step-by-step instructions on installation and usage of SAML / Shibboleth Plugin Installation in Restyaboard, refer [YouTube video](https://www.youtube.com/watch?v=5UkREHcQdjA "Watch video on SAML / Shibboleth Plugin Installation in Restyaboard")

[![SAML / Shibboleth Plugin Installation in Restyaboard](saml-shibboleth-sso-plugin-installation.gif)](https://www.youtube.com/watch?v=5UkREHcQdjA "Watch video on SAML / Shibboleth Plugin Installation in Restyaboard") 

## SAML / Shibboleth Plugin Installation

1.  Download [SAML / Shibboleth app](https://restya.com/board/apps/r_saml_shibboleth_sso "SAML / Shibboleth app")
2.  Goto your Restyaboard installation root directory. e.g., directory: `/usr/share/nginx/html/restyaboard/`
3.  Unzip the downloaded SAML / Shibboleth app to your root directory
4.  Open the command prompt in `/usr/share/nginx/html/restyaboard/client/apps/r_saml_shibboleth_sso/` path and give the executable permission to the shell file `saml_shibboleth_sso.sh`.e.g.,`chmod +x saml_shibboleth_sso.sh`
5.  Run the shell script file. e.g., `./saml_shibboleth_sso.sh`
6.  You can configure SAML app on `http://{YOUR_SERVER_NAME}/#/apps/r_saml_shibboleth_sso` path in your Restyaboard server.
7.  Clear the browser cache, and login again to view the installed SAML / Shibboleth app on your Restyaboard.