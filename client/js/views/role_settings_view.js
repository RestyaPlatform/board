/**
 * @fileOverview This file has functions related to role settings view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: acl links collection.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * RoleSettings View
 * @class RoleSettingsView
 * @constructor
 * @extends Backbone.View
 */
App.RoleSettingsView = Backbone.View.extend({
    template: JST['templates/role_settings'],
    tagName: 'section',
    className: 'clearfix row',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-update-role': 'saveRoleSettings',
        'click .js-role-name': 'roleAddForm',
        'click .js-edit': 'roleEditForm',
        'submit form#RoleAddForm': 'roleAdd',
        'submit form#BoardUserRoleAddForm': 'boardUserRoleAdd',
        'submit form#OrganizationUserRoleAddForm': 'organizationUserRoleAdd',
        'submit form#RoleEditForm': 'roleEdit',
        'submit form#BoardUserRoleEditForm': 'boardUserRoleEdit',
        'submit form#OrganizationUserRoleEditForm': 'organizationUserRoleEdit',
        'click .js-delete-board-user-role': 'deleteBoardUserRole',
        'click .js-delete-organization-user-role': 'deleteOrganizationUserRole',
        'click .js-delete-role': 'deleteRole',
        'click .js-delete-board-role': 'DeleteBoardRoleDropdown',
        'click .js-back-to-board-roleEdit': 'BackToBoardRoleEdit',
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.roles = options.roles;
        this.acl_board_links = options.acl_board_links;
        this.board_user_roles = options.board_user_roles;
        this.acl_organization_links = options.acl_organization_links;
        this.organization_user_roles = options.organization_user_roles;
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
        this.$el.html(this.template({
            acl_links: this.model,
            roles: this.roles,
            acl_board_links: this.acl_board_links,
            board_user_roles: this.board_user_roles,
            acl_organization_links: this.acl_organization_links,
            organization_user_roles: this.organization_user_roles
        }));
        $('.js-admin-role-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-user-menu, .js-admin-email-menu, .js-admin-setting-menu, .js-admin-board-menu').removeClass('active');
        _(function() {
            $('#js-question-mark').tooltip();
        }).defer();
        this.showTooltip();
        return this;
    },
    /**
     * saveRoleSettings()
     * save role alloewd acl links
     * @param e
     * @type Object(DOM event)
     */
    saveRoleSettings: function(e) {
        var self = $(e.target);
        var data = {
            'acl_link_id': self.data('acl_link_id'),
            'role_id': self.data('role_id'),
            'table': self.data('table')
        };
        var role_setting = new App.RoleSetting();
        role_setting.set(data);
        role_setting.url = api_url + 'acl_links.json';
        role_setting.save(data);
    },
    roleAddForm: function(e) {
        e.preventDefault();
        return false;
    },
    roleEditForm: function(e) {
        e.preventDefault();
        return false;
    },
    /**
     * roleAdd()
     * save role
     * @return false
     */
    roleAdd: function(e) {
        var target = $(e.target);
        var data = target.serializeObject();
        var self = this;
        var role = new App.Role();
        role.url = api_url + 'roles.json';
        role.save(data, {
            success: function(model, response) {
                self.flash('success', i18next.t('Role added successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * organizationUserRoleAdd()
     * save organization user role
     * @return false
     */
    organizationUserRoleAdd: function(e) {
        var target = $(e.target);
        var data = target.serializeObject();
        var self = this;
        var organization_user_role = new App.OrganizationUserRoles();
        organization_user_role.url = api_url + 'organization_user_roles.json';
        organization_user_role.save(data, {
            success: function(model, response) {
                self.flash('success', i18next.t('Organization user role added successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * DeleteBoardRoleDropdown()
     * Delete Board User Role Dropdown  
     * @param e
     * @type Object(DOM event)
     */
    DeleteBoardRoleDropdown: function(e) {
        var self = $(e.target);
        var user_role_id = self.attr('data-board_user_role_id');
        self.parents('.js-board-user-roleEdit-response').html('<li><div class="clearfix text-center col-xs-12"><a href="#" class="js-back-to-board-roleEdit pull-left btn btn-xs btn-link"><i class="icon-caret-left" data-board_user_role_id="' + user_role_id + '"></i></a><span class="col-xs-10 navbar-btn"><strong>' + i18next.t('Delete Role ?') + '</strong></span></div></li><li class="col-xs-12 divider"></li><li class="col-xs-12 text-left"><span class="show">' + i18next.t('Deleting an Board user role is permanent. There is no undo.This will alter existing board users role to Viewer role in all boards.') + '</span><div class="col-xs-12 btn-block navbar-btn"><a title="' + i18next.t('Delete Board User Role') + '" class="js-delete-board-user-role" data-board_user_role_id = "' + user_role_id + '"><span class="btn btn-primary col-xs-12">Delete</span></a></div></li>');
        return false;
    },
    /**
     * BackToBoardRoleEdit()
     * BoardUserRole Edit Form 
     * @param e
     * @type Object(DOM event)
     */
    BackToBoardRoleEdit: function(e) {
        var self = $(e.target);
        var user_role_id = self.attr('data-board_user_role_id');
        var user_role;
        var delete_button = '';
        this.board_user_roles.each(function(board_user_role) {
            if (parseInt(board_user_role.attributes.id) == parseInt(user_role_id)) {
                user_role = board_user_role;
            }
        });
        if (user_role) {
            self.parents('.js-board-user-roleEdit-response').next().remove();
            if (parseInt(user_role.attributes.id) > 3) {
                delete_button += '<div class="form-group"><a href="#" title="' + i18next.t('Delete') + '" class="js-delete-board-role btn btn-default col-xs-12" data-board_user_role_id="' + user_role.attributes.id + '">' + i18next.t('Delete') + '</a></div>';
            }
            delete_button += '</form></li>';
            self.parents('.js-board-user-roleEdit-response').html('<li><div class="clearfix text-center col-xs-12"><span class="col-xs-10"><strong>' + i18next.t('Edit Board User Role') + '</strong></span><i class="icon-remove cur"></i></div></li><li class="col-xs-12 divider"></li><li class="col-xs-12"><form id="BoardUserRoleEditForm" name="BoardUserRoleEditForm" class="form-horizontal col-xs-12"><input type="hidden" name="id" value="' + user_role.attributes.id + '"><div class="form-group required"><label class="sr-only control-label" for="inputEditBoardName">' + i18next.t('Name') + '</label><input type="name" name="name" value="' + user_role.attributes.name + '" id="inputEditBoardName" class="form-control js-role-name" placeholder="' + i18next.t('Name') + '" required></div><div class="form-group required"><label class="sr-only control-label" for="inputEditBoardDescription">' + i18next.t('Description') + '</label><textarea name="description" id="inputEditBoardDescription" class="form-control js-role-name" placeholder="' + i18next.t('Description') + '">' + user_role.attributes.description + '</textarea></div><div class="form-group"><label class="sr-only control-label" for="submitEditBoardUserRole" >' + i18next.t("Update") + '</label><input type="submit" class="btn btn-primary col-xs-12" id="submitEditBoardUserRole" title="' + i18next.t('Update Board User Role') + '" value="' + i18next.t('Update') + '"></div>' + delete_button + '');
        }
        return false;
    },
    /**
     * boardUserRoleAdd()
     * save board user role
     * @return false
     */
    boardUserRoleAdd: function(e) {
        var target = $(e.target);
        var data = target.serializeObject();
        var self = this;
        var board_user_role = new App.BoardUserRoles();
        board_user_role.url = api_url + 'board_user_roles.json';
        board_user_role.save(data, {
            success: function(model, response) {
                self.flash('success', i18next.t('Board user role added successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * roleEdit()
     * save user
     * @return false
     */
    roleEdit: function(e) {
        var target = $(e.currentTarget);
        var data = target.serializeObject();
        var self = this;
        var role = new App.Role();
        role.set('id', data.id);
        role.url = api_url + 'roles/' + data.id + '.json';
        role.save(data, {
            success: function(model, response) {
                self.flash('success', i18next.t('Role has been updated successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * boardUserRoleEdit()
     * Update board user role
     * @return false
     */
    boardUserRoleEdit: function(e) {
        var target = $(e.currentTarget);
        var data = target.serializeObject();
        var self = this;
        var board_user_role = new App.BoardUserRoles();
        board_user_role.set('id', data.id);
        board_user_role.url = api_url + 'board_user_roles/' + data.id + '.json';
        board_user_role.save(data, {
            success: function(model, response) {
                self.flash('success', i18next.t('Role has been updated successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * organizationUserRoleEdit()
     * Update organization user role
     * @return false
     */
    organizationUserRoleEdit: function(e) {
        var target = $(e.currentTarget);
        var data = target.serializeObject();
        var self = this;
        var organization_user_role = new App.OrganizationUserRoles();
        organization_user_role.set('id', data.id);
        organization_user_role.url = api_url + 'organization_user_roles/' + data.id + '.json';
        organization_user_role.save(data, {
            success: function(model, response) {
                self.flash('success', i18next.t('Role has been updated successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * deleteBoardUserRole()
     * Delete Board User Role
     * @return false 
     */
    deleteBoardUserRole: function(e) {
        var target = $(e.currentTarget);
        var board_user_role_id = target.attr('data-board_user_role_id');
        var self = this;

        var board_user_role = new App.BoardUserRoles();
        board_user_role.set('id', board_user_role_id);
        board_user_role.url = api_url + 'board_user_roles/' + board_user_role_id + '.json';

        board_user_role.destroy({
            success: function(model, response) {
                self.flash('success', i18next.t('Role deleted successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * deleteOrganizationUserRole()
     * Delete Organization User Role
     * @return false 
     */
    deleteOrganizationUserRole: function(e) {
        var target = $(e.currentTarget);
        var organization_user_role_id = target.attr('data-organization_user_role_id');
        var self = this;
        if (window.confirm(i18next.t('This will alter existing Organization users role to Viewer role in all organizations.'))) {
            var organization_user_role = new App.OrganizationUserRoles();
            organization_user_role.set('id', organization_user_role_id);
            organization_user_role.url = api_url + 'organization_user_roles/' + organization_user_role_id + '.json';
            organization_user_role.destroy({
                success: function(model, response) {
                    self.flash('success', i18next.t('Role deleted successfully.'));
                    app.navigate('#/roles', {
                        trigger: true,
                        replace: true
                    });
                }
            });
        } else {
            return false;
        }
    },
    /**
     * deleteRole()
     * Delete Role
     * @return false 
     */
    deleteRole: function(e) {
        var target = $(e.currentTarget);
        var role_id = target.attr('data-role_id');
        var self = this;

        var role = new App.Role();
        role.set('id', role_id);
        role.url = api_url + 'roles/' + role_id + '.json';
        role.destroy({
            success: function(model, response) {
                self.flash('success', i18next.t('Role deleted successfully.'));
                app.navigate('#/roles', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    }
});
