//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "beginTestApp.h"
#include "beginApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<beginTestApp>()
{
  InputParameters params = validParams<beginApp>();
  return params;
}

beginTestApp::beginTestApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  beginApp::registerObjectDepends(_factory);
  beginApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  beginApp::associateSyntaxDepends(_syntax, _action_factory);
  beginApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  beginApp::registerExecFlags(_factory);

  bool use_test_objs = getParam<bool>("allow_test_objects");
  if (use_test_objs)
  {
    beginTestApp::registerObjects(_factory);
    beginTestApp::associateSyntax(_syntax, _action_factory);
    beginTestApp::registerExecFlags(_factory);
  }
}

beginTestApp::~beginTestApp() {}

void
beginTestApp::registerApps()
{
  registerApp(beginApp);
  registerApp(beginTestApp);
}

void
beginTestApp::registerObjects(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new test objects here! */
}

void
beginTestApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
  /* Uncomment Syntax and ActionFactory parameters and register your new test objects here! */
}

void
beginTestApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execute flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
beginTestApp__registerApps()
{
  beginTestApp::registerApps();
}

// External entry point for dynamic object registration
extern "C" void
beginTestApp__registerObjects(Factory & factory)
{
  beginTestApp::registerObjects(factory);
}

// External entry point for dynamic syntax association
extern "C" void
beginTestApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  beginTestApp::associateSyntax(syntax, action_factory);
}

// External entry point for dynamic execute flag loading
extern "C" void
beginTestApp__registerExecFlags(Factory & factory)
{
  beginTestApp::registerExecFlags(factory);
}
