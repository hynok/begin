#include "beginApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<beginApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

beginApp::beginApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  beginApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  beginApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  beginApp::registerExecFlags(_factory);
}

beginApp::~beginApp() {}

void
beginApp::registerApps()
{
  registerApp(beginApp);
}

void
beginApp::registerObjects(Factory & factory)
{
    Registry::registerObjectsTo(factory, {"beginApp"});
}

void
beginApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & action_factory)
{
  Registry::registerActionsTo(action_factory, {"beginApp"});

  /* Uncomment Syntax parameter and register your new production objects here! */
}

void
beginApp::registerObjectDepends(Factory & /*factory*/)
{
}

void
beginApp::associateSyntaxDepends(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}

void
beginApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execution flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
beginApp__registerApps()
{
  beginApp::registerApps();
}

extern "C" void
beginApp__registerObjects(Factory & factory)
{
  beginApp::registerObjects(factory);
}

extern "C" void
beginApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  beginApp::associateSyntax(syntax, action_factory);
}

extern "C" void
beginApp__registerExecFlags(Factory & factory)
{
  beginApp::registerExecFlags(factory);
}
