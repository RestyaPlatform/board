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
        current_param = this.model.current_param;
        if (typeof(authuser) != "undefined" && !_.isEmpty(current_param) && (current_param === 'activities' || current_param === 'users' || current_param === 'user_logins' || current_param === 'roles' || current_param === 'apps' || current_param === 'settings' || current_param === 'email_templates' || current_param === 'admin_boards_list' || current_param === 'oauth_clients' || current_param === 'board_user_roles' || current_param === 'organization_user_roles')) {
            this.$el.attr('id', 'admin-panel');
        }
        this.$el.html(this.template(this.model));
        this.showTooltip();
        if (load_count === 1) {
            load_count++;
            var nodes = Array();
            var appsFunc = Array();
            appsurlFunc = {};
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
                        /* create app template element */
                        app_tmpl = document.createElement(html.split('/')[1] + '-template');
                        document.head.appendChild(app_tmpl);
                        /* create link for template element */
                        l = document.createElement('link');
                        l.setAttribute('crossorigin', 'anonymous');
                        l.rel = 'preload';
                        l.as = "fetch";
                        l.id = html.split('/')[1] + '-template';
                        l.href = html;
                        document.head.appendChild(l);
                    });
                }
                if (key === 'mutationObservers') {
                    _.each(app, function(appTmp) {
                        _.each(appTmp, function(mutation, node) {
                            if (_.isUndefined(nodes[node])) {
                                nodes[node] = Array();
                            }
                            _.each(mutation, function(appFunction, targetElement) {
                                if (nodes[node].indexOf(targetElement) === -1) {
                                    nodes[node].push(targetElement);
                                }
                                if (_.isUndefined(appsFunc[targetElement])) {
                                    appsFunc[targetElement] = Array();
                                }
                                appsFunc[targetElement].push(appFunction);
                            });
                        });
                    });
                }
                if (key === 'urlChange') {
                    _.each(app, function(appTmp) {
                        _.each(appTmp, function(funct_name, appsUrl) {
                            if (_.isUndefined(appsurlFunc[appsUrl])) {
                                appsurlFunc[appsUrl] = Array();
                            }
                            if (appsurlFunc[appsUrl].indexOf(funct_name) === -1) {
                                appsurlFunc[appsUrl].push(funct_name);
                            } else {
                                appsurlFunc[appsUrl] = Array();
                                appsurlFunc[appsUrl].push(funct_name);
                            }
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
                        setTimeout(function() {
                            _(function() {
                                _.each(appsFunc[mutationRecord.addedNodes[0].id], function(
                                    functionName
                                ) {
                                    if (typeof AppsFunction[functionName] === 'function') {
                                        AppsFunction[functionName]();
                                    }
                                });
                            }).defer();
                        }, 100);
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
        var url = location.hash;
        url = url.replace('#/users?', '');
        if (url.indexOf('filter') !== -1) {
            var query_param = url.split('&filter=');
            page_no = query_param[0].replace('page=', '');
            self.current_page = page_no + '&filter=' + query_param[1];
            self.current_param = query_param[1];
        } else if (url.indexOf('page') !== -1) {
            page_no = url.split('page=');
            self.current_page = page_no[1];
            self.current_param = 'all';
        } else {
            self.current_page = 1;
            self.current_param = 'all';
        }
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
                    sortDirection: self.sortDirection,
                    'current_param': self.current_param
                }).el);
                $('.pagination-boxes').unbind();
                $('.pagination-boxes').html('');
                if (!_.isUndefined(response._metadata) && parseInt(response._metadata.noOfPages) > 1) {
                    $('.pagination-boxes').pagination({
                        total_pages: parseInt(response._metadata.noOfPages),
                        current_page: parseInt(self.current_page),
                        display_max: 4,
                        callback: function(event, page) {
                            event.preventDefault();
                            if (page) {
                                if (!_.isUndefined(self.current_param) && self.current_param !== null && self.current_param !== 'all') {
                                    self.current_page = page + '&filter=' + self.current_param + '&sort=' + self.sortField + '&direction=' + self.sortDirection;
                                    page = self.current_page;
                                } else if (!_.isUndefined(self.current_param) && self.current_param !== null && self.current_param === 'all' && typeof self.current_page === 'string') {
                                    var current_page = self.current_page.split('&sort=');
                                    self.current_page = page + '&sort=' + current_page['1'];
                                    page = self.current_page;
                                } else {
                                    self.current_page = page + '&sort=' + self.sortField + '&direction=' + self.sortDirection;
                                    page = self.current_page;
                                }
                                app.navigate('#/' + 'users?page=' + page, {
                                    trigger: true,
                                    trigger_function: true,
                                });
                            }
                        }
                    });
                }
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
