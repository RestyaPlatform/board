/**
 * @fileOverview This file has functions related to user dashboard view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * UserDashboard View
 * @class UserDashboardView
 * @constructor
 * @extends Backbone.View
 */
App.UserDashboardView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        this.render();
    },
    events: {
        'click .dashboard-search': 'dashboardSearch'
    },
    template: JST['templates/user_dashboard'],
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        var dashboard_data = {};
        var profile_picture_path = '';
        if (!_.isEmpty(authuser.user.profile_picture_path)) {
            var hash = calcMD5(SecuritySalt + 'User' + authuser.user.id + 'png' + 'medium_thumb');
            profile_picture_path = window.location.pathname + 'img/medium_thumb/User/' + authuser.user.id + '.' + hash + '.png';
        }
        dashboard_data.user_profile_picture = profile_picture_path;
        dashboard_data.user = authuser.user;
        dashboard_data.organizations = auth_user_organizations.models;
        dashboard_data.dashboard = this.model;
        this.$el.html(this.template({
            data: dashboard_data,
        }));
        this.showTooltip();
        return this;
    },
    dashboardSearch: function(e) {
        var q = $(e.currentTarget).data('search');
        q = 'due:' + q;
        var elastic_search = new App.ElasticSearchCollection();
        elastic_search.url = api_url + 'search.json';
        elastic_search.fetch({
            data: {
                q: q,
                token: api_token
            },
            success: function(model, response) {
                response = response;
                response.result.search_term = q;
                app.navigate('#/search/' + q, {
                    trigger: false,
                    trigger_function: false,
                    replace: true
                });
                $('#search-page-result-block').html(new App.SearchPageResultView({
                    model: response
                }).el);
                $("#search-page-result").removeClass("search-block").addClass("search-block-main-hover");
                var w_height = $(window).height() - 38;
                $(".search-block-main-hover").css('height', w_height + 'px');
            }
        });
        return false;
    }
});
