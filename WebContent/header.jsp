<!DOCTYPE html>
<html>
<head><title>Test Web App for Tomkitty 7 or Other Servlet 3.0 Container</title>
<link rel="stylesheet"
      href="./css/bootstrap.min.css"
      type="text/css"/>
</head>
<body>
<nav class="navbar navbar-default" role="navigation">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">CSE135</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">Categories <b class="caret"></b></a>
          <ul class="dropdown-menu">
            <li><a href="/categories">Category 1</a></li>
          </ul>
        </li>
      </ul>
      <form class="navbar-form navbar-left" role="login">
        <div class="form-group">
          <input type="text" class="form-control" placeholder="Username">
          <input type="password" class="form-control" placeholder="Password">
        </div>
        <button type="submit" class="btn btn-default">Submit</button>
      </form>
      <ul class="nav navbar-nav navbar-right">
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">Shopping Cart <b class="caret"></b></a>
          <ul class="dropdown-menu">
            <li><a href="#">Number of Items</a></li>
            <li class="divider"></li>
            <li><a href="/shoppingcart">See Shopping Cart</a></li>
          </ul>
        </li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
<div class="container">