/**
 * @fileOverview This file has functions related to header view. This view calling from application view and login view.
 * Available Object:
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Header View
 * @class HeaderView
 * @constructor
 * @extends Backbone.View
 */
App.HeaderView = Backbone.View.extend({
    template: JST['templates/header'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click .js-open-popover': 'openPopup',
        'click .js-star-board': 'sidebarSubcribeBoard',
        'click .js-show-change-avatar-form': 'showChangeAvatarForm',
        'click .js-sort-by': 'sortBy'
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (options.users) {
            this.users = options.users;
        }
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        if (!_.isUndefined(this.users)) {
            var admins = this.users.filter(function(normal_user) {
                return normal_user.attributes.role_id === 1;
            });
            var admin_board_users = admins;
            this.admin_board_users = admin_board_users.length;
            var normal_users = this.users.filter(function(normal_user) {
                return normal_user.attributes.role_id !== 1;
            });
            var normal_board_users = normal_users;
            this.normal_board_users = normal_board_users.length;
        }
        this.render();
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.model.is_show_enable_notification = false;
        var current_param = Backbone.history.fragment.split('?');
        if (current_param[0].indexOf('/') === 0) {
            current_param[0] = current_param[0].substr(1);
        }
        var current_param_split = current_param[0].split('/');
        this.model.current_param = (current_param.indexOf('changepassword') === -1 && current_param.indexOf('login') === -1 && current_param.indexOf('forgotpassword') === -1 && current_param.indexOf('register') === -1 && current_param.indexOf('activation') === -1) ? current_param_split[0] : '';
        if (!_.isEmpty(current_param_split[0]) && current_param_split[0] === 'user_logins') {
            this.model.current_param = 'user_logins';
            current_param = 'user_logins';
        }
        if (!_.isEmpty(current_param_split[1]) && current_param_split[1] === 'list') {
            this.model.current_param = 'admin_boards_list';
        }
        if (!_.isEmpty(current_param_split[2]) && current_param_split[2] === 'changepassword') {
            this.model.current_param = 'changepassword';
        }
        if (typeof Notification != 'undefined') {
            this.model.is_show_enable_notification = (Notification.permission == 'default') ? true : false;
        }
        this.$el.html(this.template(this.model));
        this.showTooltip();
        if (load_count === 1) {
            load_count++;
            var nodes = Array();
            var appsFunc = Array();
            _.each(APPS, function(app, key) {
                var s, l, v = '';
                if (key === 'settings') {
                    s = document.createElement('script');
                    _.each(app, function(client_id, key) {
                        v += "var " + client_id.name + " = '" + client_id.value + "';";
                    });
                    s.text = v;
                    document.body.appendChild(s);
                }
                if (key === 'js') {
                    _.each(app, function(js, key) {
                        s = document.createElement('script');
                        s.type = 'text/javascript';
                        s.src = js;
                        document.body.appendChild(s);
                    });
                }
                if (key === 'css') {
                    _.each(app, function(css, key) {
                        l = document.createElement('link');
                        l.rel = 'stylesheet';
                        if (css.indexOf('r_kanban_printer') > -1) {
                            l.title = 'r_kanban_printer';
                        }
                        l.type = 'text/css';
                        l.href = css;
                        document.head.appendChild(l);
                    });
                }
                if (key === 'html') {
                    _.each(app, function(html, key) {
                        l = document.createElement('link');
                        l.rel = 'import';
                        l.href = html;
                        l.onload = function(e) {
                            var content = e.target.import;
                            var get_script = content.querySelectorAll("script");
                            _.each(get_script, function(html, key) {
                                document.body.appendChild(html.cloneNode(true));
                            });
                        };
                        document.head.appendChild(l);
                    });
                }
                if (key === 'mutationObservers') {
                    _.each(app, function(appTmp) {
                        _.each(appTmp, function(mutation, node) {
                            if (nodes[node] !== 'undefined') {
                                nodes[node] = Array();
                            }
                            _.each(mutation, function(appFunction, targetElement) {
                                if (nodes[node].indexOf(targetElement) === -1) {
                                    nodes[node].push(targetElement);
                                }
                                if (appsFunc[targetElement] !== 'undefined') {
                                    appsFunc[targetElement] = Array();
                                }
                                appsFunc[targetElement].push(appFunction);
                            });
                        });
                    });
                }
            });
            var whatToObserve = {
                childList: true
            };
            var mutationObserver = new MutationObserver(function(mutationRecords) {
                _.each(mutationRecords, function(mutationRecord) {
                    if (mutationRecord.addedNodes.length > 0 && nodes[mutationRecord.target.id].indexOf(mutationRecord.addedNodes[0].id) !== -1) {
                        _(function() {
                            _.each(appsFunc[mutationRecord.addedNodes[0].id], function(
                                functionName
                            ) {
                                AppsFunction[functionName]();
                            });
                        }).defer();
                    }
                });
            });
            for (var node in nodes) {
                var targetNode = document.getElementById(node);
                mutationObserver.observe(targetNode, whatToObserve);
            }
        }
        return this;
    },
    renderList: function() {
        var self = this;
        self.current_page = (!_.isUndefined(self.current_page)) ? self.current_page : 1;
        var users = new App.UserCollection();
        users.url = api_url + 'users.json?page=' + self.current_page;
        users.fetch({
            cache: false,
            abortPending: true,
            success: function(users, response) {
                $('#content').html(new App.UserIndexContainerView({
                    model: users,
                    filter_count: response.filter_count,
                    roles: response.roles,
                    sortField: self.sortField,
                    sortDirection: self.sortDirection
                }).el);
            }
        });
    },
    sortBy: function(e) {
        e.preventDefault();
        var sortField = $(e.currentTarget).data('field');
        if (_.isUndefined(this.sortDirection)) {
            this.sortDirection = 'desc';
        } else {
            if (this.sortDirection === 'desc') {
                this.sortDirection = 'asc';
            } else {
                this.sortDirection = 'desc';
            }
        }
        this.sortField = sortField;
        this.renderList();
    },
    /**
     * openPopup()
     * show dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    openPopup: function(e) {
        var target = $(e.target).parents('.dropdown:first');
        target.addClass('open').prev('.dropdown').removeClass('open');
        target.next('.dropdown').removeClass('open');
        return false;
    },
    /**
     * closePopup()
     * close opened dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    }
});
