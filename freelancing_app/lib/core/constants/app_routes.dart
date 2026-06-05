class AppRoutes {
  static const main = '/main';

  //auth routes
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const privacy = '/privacy';
  static const terms = '/terms';
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const join = '/join';
  static const forgotPassword = '/forgot-password';
  static const verifyEmail = '/verify-email';
  static const error = '/error';
  static const noInternet = '/no_interner';

  //admin routes
  static const adminHome = '/admin_home'; //لسا ما حطيتلها صفحه
  static const adminRequests = '/admin_requests';
  static const adminRequestDetails = '/admin_requests_details';

  //request route
  static const freelancerAccountInfo = '/freelancer_account_info';
  static const freelancerWorkAndCertificates =
      '/freelancer_work_and_certificates';
  static const clinetWork = '/clinet_work';
  static const clientAccountInfo = '/client_account_info';
  static const entryTest = '/entryTest';

  static const pending = '/pending/';
  static const approved = '/approved';
  static const rejected = '/rejected';

  //home routes
  static const home = '/home';
  static const notifications = '/notifications';

  //profile routes
  // static const profile = '/profile';
  static const myProfile = '/my_profile';
  static const userProfile = '/user_profile';

  static const personalInfo = '/personal_info';
  static const workDetails = '/work_details';
  static const userRatings = '/user_ratings';
  static const dashboard = '/dashboard';

  //search route
  static const search = '/search';
  static const searchClients = '/search_clients';
  static const searchFreelancers = '/search_freelancers';

  //chat routes
  static const chat = '/chat';
  //skills routes
  static const skillsSelection = '/skills_selection';

  //project routes
  static const createProject = '/create_project';
  static const browseProjects = '/browse_projects';
  static const projectDetails = '/project_details';
  static const myProjects = '/my_projects';
  static const activeProject = '/active_project';

  //offers routes
  static const submitOffer = '/submit_offer';
  static const projectOffers = '/project_offers';
  static const freelancerOffers = '/freelancer_offers';

  //settings routes
}
