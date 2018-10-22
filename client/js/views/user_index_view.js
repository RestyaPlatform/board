/**
 * @fileOverview This file has functions related to user index view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * UserIndex View
 * @class UserIndex
 * @constructor
 * @extends Backbone.View
 */
App.UserIndex = Backbone.View.extend({
    template: JST['templates/user'],
    tagName: 'tr',
    className: '',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-user-activity-menu': 'userActivityMenu',
        'click .js-user-board-list': 'userBoardList',
        'click .js-no-action': 'noAction',
        'click .js-change-user-role': 'changeUserRole',
        'click .js-block-user': 'blockUser',
        'click .js-unblock-user': 'unBlockUser',
        'click .js-remove-user': 'removeUser',
        'click .js-all-user-activities': 'showUserActivities',
        'submit .js-admin-change-password': 'changePassword',
        'click .js-user-view': 'gotoUserView',
        'click .js-group-member': 'AddremoveGroupuser'
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
        _.bindAll(this, 'render');
        this.model.bind('change:role_id', this.render);
        this.model.bind('change:is_active', this.render);
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            user: this.model
        }));
        if (this.model.attributes.joined_board_count !== 0) {
            this.userBoardList();
        }
        $('.js-admin-user-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-setting-menu, .js-admin-email-menu, .js-admin-role-menu, .js-admin-board-menu').removeClass('active');
        this.showTooltip();
        return this;
    },
    /**
     * gotoUserView()
     * To go to userview
     * @param e
     * @type Object(DOM event)
     *
     */
    gotoUserView: function(e) {
        e.preventDefault();
        var self = this;
        var user_id = $(e.target).data('user_id');
        app.navigate('#/user/' + user_id, {
            trigger: true,
            replace: true
        });
    },
    AddremoveGroupuser: function(e) {
        e.preventDefault();
        var self = this;
        var target = $(e.currentTarget);
        var user_id = $(target).data('user_id');
        var group_id = $(target).data('group_id');
        var group_index = $(target).data('group_index');
        var already_exists = $(target).find('.js-group-member-check').data('group_user');
        var temp_group_count = $('.js-group-memeber-count-' + user_id).text();
        var group_user_index;
        if (already_exists) {
            $.ajax({
                url: api_url + '/v1/groups/' + group_id + '/users/' + user_id + '.json?token=' + this.getToken(),
                type: 'DELETE',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    if (!_.isEmpty(self.model.overall_groups[group_index].groups_users) && !_.isUndefined(self.model.overall_groups[group_index].groups_users)) {
                        _.each(self.model.overall_groups[group_index].groups_users, function(group_user, group_user_key) {
                            if (group_user.user_id === user_id) {
                                group_user_index = group_user_key;
                            }
                        });
                        self.model.overall_groups[group_index].groups_users.splice(group_user_index, 1);
                    }
                    temp_group_count = parseInt(temp_group_count) - 1;
                    self.flash('success', i18next.t('User removed from the group successfully.'));
                    self.render();
                    _(function() {
                        $(target).parents('.js-Group-content-dropdown').addClass('open');
                    }).defer();
                    $('.js-group-memeber-count-' + user_id).text(temp_group_count);
                }
            });
        } else {
            var post_data = {
                'group_id': group_id,
                'user_id': user_id,
            };
            $.ajax({
                url: api_url + 'groups_users.json?token=' + this.getToken(),
                type: 'POST',
                data: JSON.stringify(post_data),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    if (!_.isUndefined(self.model.overall_groups) && !_.isUndefined(self.model.overall_groups[group_index].groups_users) && !_.isEmpty(self.model.overall_groups[group_index].groups_users)) {
                        self.model.overall_groups[group_index].groups_users.push({
                            'user_id': user_id
                        });
                    } else {
                        self.model.overall_groups[group_index].groups_users = [];
                        self.model.overall_groups[group_index].groups_users.push({
                            'user_id': user_id
                        });
                    }
                    temp_group_count = parseInt(temp_group_count) + 1;
                    self.flash('success', i18next.t('User added to group successfully.'));
                    self.render();
                    $('.js-group-memeber-count-' + user_id).text(temp_group_count);
                }
            });
            return false;
        }
    },
    /**
     * deleteUser()
     * delete user
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    deleteUser: function() {
        this.model.destroy();
        this.model.url = api_url + 'users/' + this.model.id + '.json';
        this.$el.remove();
        return false;
    },
    /**
     * userActivityMenu()
     * display user activity menu
     * @param e
     * @type Object(DOM event)
     */
    userActivityMenu: function(e) {
        e.preventDefault();
        $('#js-user-activity-menu-response-' + this.model.id).html(new App.UserActivityMenuView({
            model: this.model
        }).el);
    },
    /**
     * userBoardList()
     * display user baords list
     * @param e
     * @type Object(DOM event)
     */
    userBoardList: function(e) {
        var self = this;
        var user_boards = new App.BoardsUserCollection();
        user_boards.add(this.model.attributes.boards_users, {
            silent: true
        });
        for (var i = 0; i < user_boards.models.length; i++) {
            var user_board = user_boards.models[i];
            self.$el.find('#js-user-activity-menu-response-' + self.model.id).append(new App.UserBoardListView({
                model: user_board
            }).el);
        }
    },
    /**
     * changePassword()
     * update user password
     * @return false
     */
    changePassword: function(e) {
        var target = $(e.target);
        var data = target.serializeObject();
        target[0].reset();
        var user = new App.User();
        var self = this;
        user.url = api_url + 'users/' + this.model.attributes.id + '/adminchangepassword.json';
        user.save(data, {
            success: function(model, response) {
                if (response.error) {
                    if (parseInt(response.error) === 1) {
                        self.flash('danger', i18next.t('Unable to change password. Please try again.'));
                    } else if (parseInt(response.error) === 2) {
                        self.flash('danger', i18next.t('New and confirm password field must match, please try again.'));
                    }
                } else {
                    self.flash('success', i18next.t('Password has been changed successfully.'));
                }
            }
        });
        return false;
    },
    /**
     * noAction()
     * @param e
     * @type Object(DOM event)
     */
    noAction: function(e) {
        e.preventDefault();
        return false;
    },
    /**
     * changeUserRole()
     * @param e
     * @type Object(DOM event)
     */
    changeUserRole: function(e) {
        e.preventDefault();
        var role_id = $(e.currentTarget).data('role-id');
        this.model.set('role_id', role_id);
        this.model.url = api_url + 'users/' + this.model.attributes.id + '.json';
        this.model.save({
            role_id: role_id
        }, {
            patch: true
        });
    },
    /**
     * blockUser()
     * @param e
     * @type Object(DOM event)
     */
    blockUser: function(e) {
        e.preventDefault();
        this.model.set('is_active', 0);
        this.model.url = api_url + 'users/' + this.model.attributes.id + '.json';
        this.model.save({
            is_active: 0
        }, {
            patch: true
        });
    },
    /**
     * unBlockUser()
     * @param e
     * @type Object(DOM event)
     */
    unBlockUser: function(e) {
        e.preventDefault();
        this.model.set('is_active', 1);
        this.model.url = api_url + 'users/' + this.model.attributes.id + '.json';
        this.model.save({
            is_active: 1
        }, {
            patch: true
        });
    },
    /**
     * removeUser()
     * @param e
     * @type Object(DOM event)
     */
    removeUser: function(e) {
        e.preventDefault();
        this.$el.remove();
        this.model.url = api_url + 'users/' + this.model.attributes.id + '.json';
        this.flash('success', i18next.t('User deleted successfully.'));
        this.model.destroy();
    },
    showUserActivities: function(e) {
        e.preventDefault();
        var modalView = new App.ModalActivityView({
            model: this.model,
            type: 'user_listing',
            is_from: 'user_lists'
        });
        modalView.show();
        return false;
    },
    getToken: function() {
        if ($.cookie('auth') !== undefined) {
            var Auth = JSON.parse($.cookie('auth'));
            api_token = Auth.access_token;
            return api_token;
        } else {
            return false;
        }
    }
});
