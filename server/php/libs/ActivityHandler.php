<?php

class ActivityHandler
{
    private static $not_acceptable_diff_keys = array(
        'activities', // array type
        'checklist_items', // array type
        'is_archived',
        'is_deleted',
        'created',
        'modified',
        'is_offline',
        'uuid',
        'to_date',
        'temp_id'
    );
    private static $not_acceptable_diff_obj_types = array(
        'moved_card_checklist_item',
        'add_card_desc',
        'add_card_duedate',
        'delete_card_duedate',
        'add_background',
        'change_background',
        'change_visibility'
    );
    private static $acceptable_diff_obj_types = array(
        'add_card_desc',
        'add_card_desc',
        'edit_card_duedate',
        'add_background',
        'change_background',
        'change_visibility'
    );

    public static function getActivitiesObj($obj)
    {
        global $r_debug, $db_lnk, $authUser, $_server_domain_url;
        $obj_type = $obj['type'];
        if (!empty($obj['revisions']) && trim($obj['revisions']) !== '') {
            $revisions = unserialize($obj['revisions']);
            $obj['revisions'] = $revisions;
            $diff = array();
            if (!empty($revisions['new_value'])) {
                foreach ($revisions['new_value'] as $key => $value) {
                    if (!in_array($key, ActivityHandler::$not_acceptable_diff_keys, true) && !in_array($obj_type, ActivityHandler::$not_acceptable_diff_obj_types, true)) {
                        $old_val = (isset($revisions['old_value'][$key]) && $revisions['old_value'][$key] != null && $revisions['old_value'][$key] != 'null') ? $revisions['old_value'][$key] : '';
                        $new_val = (isset($revisions['new_value'][$key]) && $revisions['new_value'][$key] != null && $revisions['new_value'][$key] != 'null') ? $revisions['new_value'][$key] : '';
                        $diff[] = nl2br(getRevisiondifference($old_val, $new_val));
                    }
                    if (in_array($obj_type, ActivityHandler::$acceptable_diff_obj_types, true)) {
                        $diff[] = $revisions['new_value'][$key];
                    }
                }
            } else if (!empty($revisions['old_value']) && isset($obj_type) && $obj_type == 'delete_card_comment') {
                $diff[] = nl2br(getRevisiondifference($revisions['old_value'], ''));
            }
            if (isset($diff)) {
                $obj['difference'] = $diff;
            }
        }
        if ($obj_type === 'add_board_user') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['board_user'] = executeQuery('SELECT * FROM boards_users_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'add_list') {
            $obj_val_arr = array(
                $obj['list_id']
            );
            $obj['list'] = executeQuery('SELECT * FROM lists_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'change_list_position') {
            $obj_val_arr = array(
                $obj['list_id']
            );
            $obj['list'] = executeQuery('SELECT position, board_id FROM lists WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'add_card') {
            $obj_val_arr = array(
                $obj['card_id']
            );
            $obj['card'] = executeQuery('SELECT * FROM cards_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'copy_card') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['card'] = executeQuery('SELECT * FROM cards_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'add_card_checklist') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['checklist'] = executeQuery('SELECT * FROM checklists_listing WHERE id = $1', $obj_val_arr);
            $obj['checklist']['checklists_items'] = json_decode($obj['checklist']['checklists_items'], true);
        } else if ($obj_type === 'add_card_label') {
            $obj_val_arr = array(
                $obj['card_id']
            );
            $s_result = pg_query_params($db_lnk, 'SELECT * FROM cards_labels_listing WHERE  card_id = $1', $obj_val_arr);
            while ($row = pg_fetch_assoc($s_result)) {
                $obj['labels'][] = $row;
            }
        } else if ($obj_type === 'add_card_voter') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['voter'] = executeQuery('SELECT * FROM card_voters_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'add_card_user') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['user'] = executeQuery('SELECT * FROM cards_users_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'update_card_checklist') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['checklist'] = executeQuery('SELECT * FROM checklists_listing WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'add_checklist_item' || $obj_type === 'update_card_checklist_item' || $obj_type === 'moved_card_checklist_item') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['item'] = executeQuery('SELECT * FROM checklist_items WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'add_card_attachment') {
            $obj_val_arr = array(
                $obj['foreign_id']
            );
            $obj['attachment'] = executeQuery('SELECT * FROM card_attachments WHERE id = $1', $obj_val_arr);
        } else if ($obj_type === 'change_card_position') {
            $obj_val_arr = array(
                $obj['card_id']
            );
            $obj['card'] = executeQuery('SELECT position FROM cards_listing WHERE id = $1', $obj_val_arr);
        }
        return $obj;
    }
}