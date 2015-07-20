/**
 * @fileOverview This file has functions related to login view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * Login View
 * @class LoginView
 * @constructor
 * @extends Backbone.View
 */
App.LoginView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
        this.changeFavicon();
    },
    template: JST['templates/login'],
    tagName: 'section',
    className: 'clearfix',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit': 'login'
    },
    /**
     * login()
     * user login
     * @return false
     *
     */
    login: function(e) {
        var self = this;
        var target = $(e.target);
        var data = target.serializeObject();
        var user = new App.User();
        user.url = api_url + 'users/login.json';
        user.save(data, {
            success: function(model, response) {
                authuser = response;
                if (!_.isUndefined(response.access_token)) {
                    window.sessionStorage.setItem('auth', JSON.stringify(response));
                    api_token = response.access_token;
                    var links = JSON.parse(response.links);
                    window.sessionStorage.setItem('links', response.links);
                    role_links.reset();
                    if (!_.isEmpty(links)) {
                        role_links.add(links);
                    }
                    var organizations = authuser.user.organizations;
                    authuser.user.organizations = new App.OrganizationCollection();
                    authuser.user.organizations.add(organizations);
                    self.changeFavicon(response.user.notify_count);
                    this.headerView = new App.HeaderView({
                        model: model
                    });
                    $('#header').html(this.headerView.el);
                    app.navigate('#/boards', {
                        trigger: true,
                        replace: true
                    });
                    //self.flash('success', 'Wellcome ' + authuser.user.username);
                } else {
                    $('input#inputPassword', target).val('');
                    self.flash('danger', response.error);
                }

            }
        });
        return false;
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template());
        this.showTooltip();
        return this;
    },
    /**
     * changeFavicon()
     * update notification count in favicon
     * @param count
     * @type number
     *
     */
    changeFavicon: function(count) {
        if (!_.isUndefined(count) && count !== '0') {
            favicon.badge(count);
        }
    }
});
